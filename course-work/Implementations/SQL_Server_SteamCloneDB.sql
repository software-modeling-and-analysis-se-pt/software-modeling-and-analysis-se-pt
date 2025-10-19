CREATE DATABASE SteamCloneDB
GO

USE SteamCloneDB
GO

CREATE SCHEMA Accounts
GO

CREATE SCHEMA Users
GO

CREATE SCHEMA Developers
GO

CREATE SCHEMA Publishers
GO

CREATE SCHEMA Games
GO

CREATE SCHEMA Tags
GO

CREATE SCHEMA Orders
GO

CREATE SCHEMA Reviews
GO

CREATE TABLE Accounts.Accounts (
	AccountId INT IDENTITY(1, 1) NOT NULL,
	Email VARCHAR(255) NOT NULL UNIQUE,
	PasswordHash VARCHAR(255) NOT NULL,
	Country VARCHAR(255),
	[Role] VARCHAR(32) NOT NULL DEFAULT 'User',
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),

	CONSTRAINT PK_Accounts_AccountId PRIMARY KEY(AccountId)
);

CREATE TABLE Users.Users (
	UserId INT IDENTITY(1, 1) NOT NULL,
	AccountId INT NOT NULL,
	Username VARCHAR(255) NOT NULL UNIQUE,
	DateOfBirth DATE,
	JoinedDate DATE NOT NULL DEFAULT GETDATE(),
	WalletBalance DECIMAL(16, 4) NOT NULL DEFAULT 0,

	CONSTRAINT PK_Users_UserId PRIMARY KEY(UserId),
	CONSTRAINT FK_Users_Accounts_AccountId FOREIGN KEY(AccountId) REFERENCES Accounts.Accounts(AccountId) ON DELETE CASCADE
);

CREATE TABLE Developers.Developers (
	DeveloperId INT IDENTITY(1, 1) NOT NULL,
	StudioName VARCHAR(255) NOT NULL UNIQUE,
	Website VARCHAR(255),
	FoundedAt DATE NOT NULL DEFAULT GETDATE(),

	CONSTRAINT PK_Developers_DeveloperId PRIMARY KEY(DeveloperId)
);

CREATE TABLE Publishers.Publishers (
	PublisherId INT IDENTITY(1, 1) NOT NULL,
	[Name] VARCHAR(255) NOT NULL UNIQUE,
	Website VARCHAR(255),
	Email VARCHAR(320),
	FoundedAt DATE NOT NULL DEFAULT GETDATE(),
	Country VARCHAR(56),

	CONSTRAINT PK_Publishers_PublisherId PRIMARY KEY(PublisherId)
);

CREATE TABLE Games.Games (
    GameId INT IDENTITY(1,1) NOT NULL,
	[Name] VARCHAR(255) NOT NULL,
	Price DECIMAL(16, 4) NOT NULL DEFAULT 0,
	ReleaseDate DATE NOT NULL DEFAULT GETDATE(),
	[Description] VARCHAR(255),
	Genre VARCHAR(100),
	AgeRating VARCHAR(20),

	DeveloperId INT NOT NULL,
	PublisherId INT NOT NULL,

	CONSTRAINT CK_Games_Price CHECK (Price >= 0),
	
	CONSTRAINT PK_Games_GameId PRIMARY KEY (GameId),
	CONSTRAINT FK_Games_Developers_DeveloperId FOREIGN KEY(DeveloperId) REFERENCES Developers.Developers(DeveloperId),
	CONSTRAINT FK_Games_Publishers_PublisherId FOREIGN KEY(PublisherId) REFERENCES Publishers.Publishers(PublisherId)
);

CREATE TABLE Tags.Tags (
	TagId INT IDENTITY(1, 1) NOT NULL,
	[Name] VARCHAR(100) NOT NULL UNIQUE,
	[Description] VARCHAR(255),

	CONSTRAINT PK_Tags_TagId PRIMARY KEY (TagId)
);

CREATE TABLE Games.GameTags (
	GameId INT NOT NULL,
	TagId INT NOT NULL,
	CONSTRAINT PK_GameTags PRIMARY KEY (GameId, TagId),
	CONSTRAINT FK_GameTags_Games_GameId FOREIGN KEY(GameId) REFERENCES Games.Games(GameId) ON DELETE CASCADE,
	CONSTRAINT FK_GameTags_Tags_TagId FOREIGN KEY(TagId) REFERENCES Tags.Tags(TagId) ON DELETE CASCADE
);

CREATE TABLE Orders.Orders (
	OrderId INT IDENTITY(1,1) NOT NULL,
	UserId INT NOT NULL,
	OrderDate DATETIME NOT NULL DEFAULT GETDATE(),
	[Status] VARCHAR(30) NOT NULL DEFAULT 'Pending',
	PaymentMethod VARCHAR(50),
	Currency CHAR(3) NOT NULL DEFAULT 'EUR',
	TotalPrice DECIMAL(16,4) NOT NULL CHECK (TotalPrice >= 0),
	CompletedAt DATETIME NULL,

	CONSTRAINT CK_Orders_Status CHECK ([Status] IN ('Pending', 'Completed', 'Cancelled')),
	CONSTRAINT PK_Orders_OrderId PRIMARY KEY (OrderId),
	CONSTRAINT FK_Orders_Users_UserId FOREIGN KEY(UserId) REFERENCES Users.Users(UserId) ON DELETE CASCADE
);

CREATE TABLE Orders.OrderItems (
	OrderItemId INT IDENTITY(1, 1) NOT NULL,
	OrderId INT NOT NULL,
	GameId INT NOT NULL,
	OrderedAtPrice DECIMAL(16, 4) NOT NULL CHECK (OrderedAtPrice >= 0),
	ItemName VARCHAR(255),

	CONSTRAINT UQ_OrderId_GameID UNIQUE (OrderId, GameId),
	CONSTRAINT PK_OrderItems_OrderItemId PRIMARY KEY(OrderItemId),
	CONSTRAINT FK_OrderItems_Orders_OrderId FOREIGN KEY(OrderId) REFERENCES Orders.Orders(OrderId) ON DELETE CASCADE,
	CONSTRAINT FK_OrderItems_Games_GameId FOREIGN KEY(GameId) REFERENCES Games.Games(GameId) ON DELETE CASCADE
);

CREATE TABLE Reviews.Reviews (
	ReviewId INT IDENTITY(1, 1) NOT NULL,
	UserId INT NOT NULL,
	GameId INT NOT NULL,
	Rating SMALLINT NOT NULL,
	ReviewDate DATETIME NOT NULL DEFAULT GETDATE(),
	ReviewText VARCHAR(2000),

	CONSTRAINT CK_Reviews_Rating CHECK (Rating BETWEEN 1 AND 10),
	CONSTRAINT UQ_UserId_GameId UNIQUE (UserId, GameId),
	CONSTRAINT FK_Reviews_Users_UserId FOREIGN KEY(UserId) REFERENCES Users.Users(UserId) ON DELETE CASCADE,
	CONSTRAINT FK_Reviews_Games_GameId FOREIGN KEY(GameId) REFERENCES Games.Games(GameId) ON DELETE CASCADE
);

CREATE INDEX idx_Games_DeveloperId ON Games.Games(DeveloperId);
CREATE INDEX idx_Games_PublisherId ON Games.Games(PublisherId);

CREATE INDEX idx_Orders_User_Id ON Orders.Orders(UserId);

CREATE INDEX idx_OrderItems_GameId ON Orders.OrderItems(GameId);
CREATE INDEX idx_OrderItems_OrderId ON Orders.OrderItems(OrderId);

CREATE INDEX idx_Reviews_GameId ON Reviews.Reviews(GameId);
CREATE INDEX idx_Reviews_UserId ON Reviews.Reviews(UserId);
CREATE INDEX idx_Reviews_GameId_UserId ON Reviews.Reviews(GameId, UserId);


-- Stored Procedures
GO

CREATE PROCEDURE Orders.usp_UpdateOrderStatus(@OrderId INT, @NewStatus VARCHAR(30))
AS
BEGIN
    SET NOCOUNT ON;

    IF (@NewStatus NOT IN ('Pending', 'Completed', 'Cancelled'))
        THROW 50002, 'Invalid order status.', 1;

    UPDATE Orders.Orders
    SET [Status] = @NewStatus
    WHERE OrderId = @OrderId;
END
GO

CREATE PROCEDURE Orders.usp_CreateOrder
    @UserId INT,
    @PaymentMethod VARCHAR(50),
    @Currency CHAR(3),
    @GameIds NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OrderId INT;

    INSERT INTO Orders.Orders (UserId, PaymentMethod, Currency, TotalPrice)
    VALUES (@UserId, @PaymentMethod, @Currency, 0);

    SET @OrderId = SCOPE_IDENTITY();

    INSERT INTO Orders.OrderItems (OrderId, GameId, OrderedAtPrice)
    SELECT @OrderId, g.GameId, g.Price
    FROM STRING_SPLIT(@GameIds, ',') AS s
    JOIN Games.Games AS g ON g.GameId = TRY_CAST(s.value AS INT);

    UPDATE o
    SET o.TotalPrice = (
        SELECT SUM(oi.OrderedAtPrice)
        FROM Orders.OrderItems oi
        WHERE oi.OrderId = o.OrderId
    )
    FROM Orders.Orders AS o
    WHERE o.OrderId = @OrderId;

    SELECT @OrderId AS NewOrderId;
END
GO

-- Functions

CREATE FUNCTION Users.fn_GetUserTotalSpent(@UserId INT)
RETURNS DECIMAL(16, 4)
AS
BEGIN
    DECLARE @Total DECIMAL(16, 4);

    SELECT @Total = ISNULL(SUM(o.TotalPrice), 0)
    FROM Orders.Orders AS o
    WHERE o.UserId = @UserId
		AND o.[Status] = 'Completed';

    RETURN @Total;
END
GO

CREATE FUNCTION Games.fn_GetGameAverageRating(@GameId INT)
RETURNS DECIMAL(4,2)
AS
BEGIN
    DECLARE @AvgRating DECIMAL(4,2);

    SELECT @AvgRating = AVG(CAST(Rating AS DECIMAL(4,2)))
    FROM Reviews.Reviews
    WHERE GameId = @GameId;

    RETURN ISNULL(@AvgRating, 0);
END
GO

-- Triggers

CREATE TRIGGER Orders.trg_Orders_OnCompleted_DeductWallet
ON Orders.Orders
AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	IF NOT EXISTS (
		SELECT 1
		FROM INSERTED AS i
		JOIN DELETED AS d ON d.OrderId = i.OrderId
		WHERE i.[Status] = 'Completed' AND ISNULL(d.[Status], '') <> 'Completed'
	) RETURN;

	IF EXISTS (
		SELECT 1
		FROM INSERTED AS i
		JOIN DELETED AS d ON d.OrderId = i.OrderId
		JOIN Orders AS o ON o.OrderId = i.OrderId
		JOIN Users.Users AS u ON u.UserId = o.UserId
		WHERE i.[Status] = 'Completed'
			AND ISNULL(d.[Status], '') <> 'Completed'
			AND u.WalletBalance < o.TotalPrice
		GROUP BY u.UserId
		HAVING SUM(o.TotalPrice) > MAX(u.WalletBalance)
	)
		THROW 50001, 'Insufficient wallet balance to complete the order.', 1;

	UPDATE u
	SET u.WalletBalance = u.WalletBalance - x.TotalTotalPrice
	FROM Users.Users AS u
	JOIN (
		SELECT u.UserId, SUM(o.TotalPrice) AS TotalTotalPrice
		FROM INSERTED AS i
		JOIN DELETED AS d ON d.OrderId = i.OrderId
		JOIN Orders AS o ON o.OrderId = i.OrderId
		JOIN Users.Users u ON u.UserId = o.UserId
		WHERE i.[Status] = 'Completed'
		  AND ISNULL(d.[Status], '') <> 'Completed'
		GROUP BY u.UserId
	) AS x ON u.UserId = x.UserId;
END
GO

CREATE TRIGGER Orders.trg_Orders_SetCompletedAt_When_Status_Is_Completed
ON Orders.Orders
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE o
    SET o.CompletedAt = GETDATE()
    FROM Orders.Orders AS o
    JOIN INSERTED AS i ON o.OrderId = i.OrderId
    JOIN DELETED AS d ON d.OrderId = i.OrderId
    WHERE i.[Status] = 'Completed'
		AND ISNULL(d.[Status], '') <> 'Completed';
END
GO
