/*
    UniPortfolioDB Database Script
    Repository: jvesteban/Portfolio
    Target: SQL Server / SQL Server Express

    This schema matches the current ASP.NET Web Forms application:
      - Users
      - EducationHistory

    The application currently uses direct parameterized SQL commands.
    The stored procedures below are provided as the database layer for
    future/current refactoring to stored-procedure-based data access.
*/

USE master;
GO

IF DB_ID(N'UniPortfolioDB') IS NULL
BEGIN
    CREATE DATABASE UniPortfolioDB;
END
GO

USE UniPortfolioDB;
GO

/* =========================================================
   SCHEMA
   ========================================================= */
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'dbo')
BEGIN
    EXEC(N'CREATE SCHEMA dbo');
END
GO

/* =========================================================
   TABLE: Users
   ========================================================= */
IF OBJECT_ID(N'dbo.Users', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Users
    (
        UserId         INT IDENTITY(1,1) NOT NULL,
        FirstName      NVARCHAR(100) NOT NULL,
        Surname        NVARCHAR(100) NOT NULL,
        Username       NVARCHAR(50) NOT NULL,
        Email          NVARCHAR(255) NOT NULL,
        ContactNumber  NVARCHAR(30) NULL,
        [Password]     NVARCHAR(255) NOT NULL,
        [Role]         NVARCHAR(20) NOT NULL
            CONSTRAINT DF_Users_Role DEFAULT (N'Student'),
        Headline       NVARCHAR(255) NULL,
        Bio            NVARCHAR(MAX) NULL,
        ImageUrl       NVARCHAR(500) NULL,
        PortfolioUrl   NVARCHAR(500) NULL,
        Education      NVARCHAR(MAX) NULL,
        Skills         NVARCHAR(MAX) NULL,
        Hobbies        NVARCHAR(MAX) NULL,

        CONSTRAINT PK_Users PRIMARY KEY CLUSTERED (UserId),
        CONSTRAINT UQ_Users_Username UNIQUE (Username),
        CONSTRAINT UQ_Users_Email UNIQUE (Email),
        CONSTRAINT CK_Users_Role CHECK ([Role] IN (N'Admin', N'Student'))
    );
END
GO

/* =========================================================
   TABLE: EducationHistory
   ========================================================= */
IF OBJECT_ID(N'dbo.EducationHistory', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.EducationHistory
    (
        EducationId      INT IDENTITY(1,1) NOT NULL,
        UserId           INT NOT NULL,
        SchoolLevel      NVARCHAR(50) NOT NULL,
        SchoolName       NVARCHAR(255) NOT NULL,
        CourseOrStrand   NVARCHAR(255) NULL,
        YearOrGradeLevel NVARCHAR(100) NULL,
        SchoolYearRange  NVARCHAR(50) NOT NULL,
        HonorsOrNotes    NVARCHAR(500) NULL,

        CONSTRAINT PK_EducationHistory PRIMARY KEY CLUSTERED (EducationId),
        CONSTRAINT FK_EducationHistory_Users
            FOREIGN KEY (UserId)
            REFERENCES dbo.Users(UserId)
            ON DELETE CASCADE,
        CONSTRAINT CK_EducationHistory_SchoolLevel
            CHECK (SchoolLevel IN
                (N'College', N'Senior High School', N'Junior High School', N'Elementary'))
    );
END
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_EducationHistory_UserId'
      AND object_id = OBJECT_ID(N'dbo.EducationHistory')
)
BEGIN
    CREATE INDEX IX_EducationHistory_UserId
        ON dbo.EducationHistory(UserId, EducationId DESC);
END
GO

/* =========================================================
   STORED PROCEDURES
   ========================================================= */

CREATE OR ALTER PROCEDURE dbo.usp_User_CheckExists
    @Username NVARCHAR(50),
    @Email    NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT COUNT(1) AS ExistingUserCount
    FROM dbo.Users
    WHERE Username = @Username
       OR Email = @Email;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_User_RegisterStudent
    @FirstName     NVARCHAR(100),
    @Surname       NVARCHAR(100),
    @Username      NVARCHAR(50),
    @Email         NVARCHAR(255),
    @ContactNumber NVARCHAR(30) = NULL,
    @Password      NVARCHAR(255),
    @Headline      NVARCHAR(255) = N'Student at UniCollege',
    @Bio           NVARCHAR(MAX) = N'Welcome to my student portfolio!',
    @ImageUrl      NVARCHAR(500) = NULL,
    @PortfolioUrl  NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Users
        WHERE Username = @Username
           OR Email = @Email
    )
    BEGIN
        THROW 50001, 'Username or Email address is already registered.', 1;
    END;

    INSERT INTO dbo.Users
    (
        FirstName, Surname, Username, Email, ContactNumber, [Password],
        [Role], Headline, Bio, ImageUrl, PortfolioUrl, Education, Skills, Hobbies
    )
    VALUES
    (
        @FirstName, @Surname, @Username, @Email, @ContactNumber, @Password,
        N'Student', @Headline, @Bio, @ImageUrl, @PortfolioUrl, N'', N'', N''
    );

    SELECT CAST(SCOPE_IDENTITY() AS INT) AS UserId;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_User_Login
    @Input    NVARCHAR(255),
    @Password NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        UserId,
        FirstName,
        Surname,
        [Role]
    FROM dbo.Users
    WHERE (Username = @Input OR Email = @Input)
      AND [Password] = @Password;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_User_GetById
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        UserId,
        FirstName,
        Surname,
        Username,
        Email,
        ContactNumber,
        [Role],
        Headline,
        Bio,
        ImageUrl,
        PortfolioUrl,
        Education,
        Skills,
        Hobbies
    FROM dbo.Users
    WHERE UserId = @UserId;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_User_GetAll
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        UserId,
        FirstName + N' ' + Surname AS FullName,
        Username,
        Email,
        ContactNumber,
        [Role],
        Headline,
        Bio,
        ImageUrl,
        PortfolioUrl,
        Education,
        Skills,
        Hobbies
    FROM dbo.Users
    ORDER BY UserId DESC;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_User_GetStudents
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        UserId,
        [Role],
        Surname,
        FirstName,
        Email,
        ContactNumber,
        Headline,
        Bio,
        ImageUrl,
        PortfolioUrl
    FROM dbo.Users
    WHERE [Role] = N'Student'
    ORDER BY Surname, FirstName;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_User_UpdateProfile
    @UserId        INT,
    @FirstName     NVARCHAR(100),
    @Surname       NVARCHAR(100),
    @Email         NVARCHAR(255),
    @ContactNumber NVARCHAR(30) = NULL,
    @Headline      NVARCHAR(255) = NULL,
    @PortfolioUrl  NVARCHAR(500) = NULL,
    @Skills        NVARCHAR(MAX) = NULL,
    @Hobbies       NVARCHAR(MAX) = NULL,
    @Bio           NVARCHAR(MAX) = NULL,
    @ImageUrl      NVARCHAR(500) = NULL,
    @UpdateImage   BIT = 0
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE UserId = @UserId)
    BEGIN
        THROW 50002, 'User does not exist.', 1;
    END;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Users
        WHERE Email = @Email
          AND UserId <> @UserId
    )
    BEGIN
        THROW 50003, 'Email address is already registered to another user.', 1;
    END;

    UPDATE dbo.Users
    SET
        FirstName = @FirstName,
        Surname = @Surname,
        Email = @Email,
        ContactNumber = @ContactNumber,
        Headline = @Headline,
        PortfolioUrl = @PortfolioUrl,
        Skills = @Skills,
        Hobbies = @Hobbies,
        Bio = @Bio,
        ImageUrl = CASE WHEN @UpdateImage = 1 THEN @ImageUrl ELSE ImageUrl END
    WHERE UserId = @UserId;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_Education_GetByUser
    @UserId INT,
    @SchoolLevel NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        EducationId,
        SchoolLevel,
        SchoolName,
        CourseOrStrand,
        YearOrGradeLevel,
        SchoolYearRange,
        HonorsOrNotes
    FROM dbo.EducationHistory
    WHERE UserId = @UserId
      AND (@SchoolLevel IS NULL OR SchoolLevel = @SchoolLevel)
    ORDER BY EducationId DESC;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_Education_Add
    @UserId           INT,
    @SchoolLevel      NVARCHAR(50),
    @SchoolName       NVARCHAR(255),
    @CourseOrStrand   NVARCHAR(255) = NULL,
    @YearOrGradeLevel NVARCHAR(100) = NULL,
    @SchoolYearRange  NVARCHAR(50),
    @HonorsOrNotes    NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE UserId = @UserId)
    BEGIN
        THROW 50004, 'User does not exist.', 1;
    END;

    INSERT INTO dbo.EducationHistory
    (
        UserId,
        SchoolLevel,
        SchoolName,
        CourseOrStrand,
        YearOrGradeLevel,
        SchoolYearRange,
        HonorsOrNotes
    )
    VALUES
    (
        @UserId,
        @SchoolLevel,
        @SchoolName,
        @CourseOrStrand,
        @YearOrGradeLevel,
        @SchoolYearRange,
        @HonorsOrNotes
    );

    SELECT CAST(SCOPE_IDENTITY() AS INT) AS EducationId;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_Education_Delete
    @EducationId INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.EducationHistory
    WHERE EducationId = @EducationId;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_User_Delete
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.Users
    WHERE UserId = @UserId;
END
GO

/* =========================================================
   OPTIONAL INITIAL ADMIN ACCOUNT
   Uncomment and replace the values before executing if needed.

   INSERT INTO dbo.Users
   (
       FirstName, Surname, Username, Email, ContactNumber,
       [Password], [Role], Headline, Bio
   )
   VALUES
   (
       N'Admin', N'User', N'admin', N'admin@example.com', NULL,
       N'CHANGE_THIS_PASSWORD', N'Admin',
       N'System Administrator', N'UniPortfolio administrator account.'
   );
   ========================================================= */

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO
