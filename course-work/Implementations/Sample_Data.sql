USE SteamCloneDB
GO

INSERT INTO Accounts.Accounts (Email, [Role], PasswordHash, Country)
VALUES
('alice@example.com', 'User', 'hash_12345', 'Germany'),
('bob@example.com', 'User', 'hash_54321', 'USA'),
('charlie@example.com', 'Developer', 'hash_abc12', 'UK'),
('diana@example.com', 'Developer', 'hash_xyz98', 'Japan'),
('eve@example.com', 'User', 'hash_99999', 'Canada'),
('frank@example.com', 'User', 'hash_55555', 'France'),
('grace@example.com', 'User', 'hash_11111', 'Spain'),
('henry@example.com', 'Developer', 'hash_dev77', 'Sweden'),
('josh@example.com', 'Developer', 'hash_dev88', 'USA'),
('petar@example.com', 'User', 'hash_user681', 'Bulgaria');

INSERT INTO Users.Users (AccountId, Username, DateOfBirth, WalletBalance)
VALUES
(1, 'AliceGamer', '1995-04-15', 50.00),
(2, 'BobTheBuilder', '1990-08-23', 75.50),
(3, 'CharliePlays', '1998-12-01', 20.25),
(4, 'Diana', '1995-04-15', 10.00),
(5, 'Eve', '1990-08-23', 5.00),
(6, 'FrankyGames', '1993-06-12', 35.40),
(7, 'Grace4Fun', '1999-11-05', 1250.00),
(8, 'SharkAttack', '2001-09-29', 15.75),
(9, 'SomeDude', '1993-06-12', 5.00),
(10, 'PGeorgiev', '1999-11-05', 60.25);

INSERT INTO Developers.Developers (AccountId, StudioName, Website, FoundedAt)
VALUES
(3, 'PixelForge Studios', 'https://pixelforge.dev', '2015-06-01'),
(4, 'SamuraiCode', 'https://samuraicode.jp', '2012-09-15'),
(3, 'NeonWorks', 'https://neonworks.io', '2018-01-20'),
(4, 'Koi Interactive', 'https://koi.games', '2010-03-10'),
(7, '8BitLabs', 'https://8bitlabs.com', '2016-07-07'),
(8, 'FrostByte Studios', 'https://frostbyte.se', '2013-12-20'),
(9, 'DreamForge', 'https://dreamforge.us', '2011-07-17'),
(7, 'PixelPanda', 'https://pixelpanda.io', '2017-04-03'),
(9, 'CodeNest Games', 'https://codenest.dev', '2019-09-01'),
(8, 'ArcticWolf Interactive', 'https://arcticwolf.se', '2015-01-25');

INSERT INTO Publishers.Publishers ([Name], Website, Email, FoundedAt, Country)
VALUES
('EpicPlay Publishing', 'https://epicplay.com', 'contact@epicplay.com', '2005-04-01', 'USA'),
('DragonSoft', 'https://dragonsoft.jp', 'info@dragonsoft.jp', '2008-11-11', 'Japan'),
('BlueSky Media', 'https://blueskymedia.co.uk', 'team@blueskymedia.co.uk', '2010-09-09', 'UK'),
('Unity Interactive', 'https://unityinteractive.com', 'hello@unityinteractive.com', '2012-01-15', 'Canada'),
('NovaGames', 'https://novagames.eu', 'support@novagames.eu', '2016-07-20', 'Germany'),
('GoldenLeaf Studios', 'https://goldenleaf.co', 'contact@goldenleaf.co', '2013-03-14', 'France'),
('Firefly Entertainment', 'https://fireflyent.com', 'info@fireflyent.com', '2018-06-06', 'USA'),
('CrimsonPeak Games', 'https://crimsonpeak.games', 'team@crimsonpeak.games', '2020-10-10', 'Sweden'),
('SunsetWorks', 'https://sunsetworks.es', 'support@sunsetworks.es', '2017-07-12', 'Spain'),
('IndieVerse', 'https://indieverse.it', 'hello@indieverse.it', '2021-09-09', 'Italy');

INSERT INTO Games.Games ([Name], Price, ReleaseDate, [Description], Genre, AgeRating, DeveloperId, PublisherId)
VALUES
('Cyber Drift', 29.99, '2021-05-10', 'Fast-paced cyberpunk racing game.', 'Racing', '12+', 1, 1),
('Shadow Blades', 49.99, '2020-11-21', 'Ninja action adventure through ancient Japan.', 'Action', '16+', 2, 2),
('Neon Skies', 19.99, '2022-02-14', 'Relaxing flight through futuristic cities.', 'Simulation', '3+', 3, 3),
('Pixel Dungeon', 14.99, '2019-08-09', 'Retro dungeon crawler full of treasures.', 'RPG', '7+', 5, 5),
('Samurai Rebirth', 39.99, '2023-09-30', 'Epic sword fighting with immersive story.', 'Action', '16+', 4, 4),
('Frozen Depths', 24.99, '2020-12-18', 'Survive icy caves and uncover lost relics.', 'Survival', '12+', 6, 6),
('Dream Tides', 19.99, '2021-07-07', 'Sail across mystical islands and battle sea spirits.', 'Adventure', '7+', 7, 7),
('PixelPanda Park', 9.99, '2022-04-01', 'Cute management sim with adorable animals.', 'Simulation', '3+', 8, 10),
('Code Breaker 2049', 59.99, '2023-11-11', 'Sci-fi puzzle thriller for the future.', 'Puzzle', '12+', 9, 8),
('Wolf Run', 34.99, '2024-03-05', 'Fast-paced winter action adventure.', 'Action', '16+', 10, 9);

INSERT INTO Tags.Tags ([Name], [Description])
VALUES
('Multiplayer', 'Supports online and local multiplayer gameplay.'),
('Singleplayer', 'Designed for solo play.'),
('Adventure', 'Exploration-focused gameplay.'),
('Pixel Art', 'Stylized retro pixel visuals.'),
('Futuristic', 'Set in a science fiction or cyberpunk world.'),
('Survival', 'Focus on resource management and endurance.'),
('Simulation', 'Player controls or manages real-like systems.'),
('Co-op', 'Play together with friends cooperatively.'),
('Fantasy', 'Set in a world of magic or mythical creatures.'),
('Strategy', 'Requires planning, resource management, or tactics.');

INSERT INTO Games.GameTags (GameId, TagId)
VALUES
(1, 1),
(1, 5),
(2, 2),
(2, 3),
(3, 5),
(4, 4),
(4, 3),
(5, 2),
(5, 3),
(3, 2),
(6, 6),
(6, 3),
(7, 4),
(7, 1),
(8, 2),
(8, 3),
(9, 5),
(9, 1),
(10, 6),
(10, 3);


INSERT INTO Orders.Orders (UserId, [Status], PaymentMethod, Currency, TotalPrice, CompletedAt)
VALUES
(1, 'Completed', 'Credit Card', 'EUR', 49.99, '2023-01-10'),
(2, 'Completed', 'PayPal', 'EUR', 29.99, '2023-03-22'),
(3, 'Pending', 'Credit Card', 'EUR', 19.99, NULL),
(4, 'Completed', 'GiftCard', 'EUR', 14.99, '2024-05-12'),
(5, 'Cancelled', 'Debit Card', 'EUR', 39.99, NULL),
(6, 'Completed', 'Credit Card', 'EUR', 24.99, '2023-02-10'),
(7, 'Completed', 'PayPal', 'EUR', 19.99, '2023-05-15'),
(8, 'Pending', 'GiftCard', 'EUR', 9.99, NULL),
(9, 'Completed', 'Debit Card', 'EUR', 59.99, '2024-08-19'),
(10, 'Completed', 'Credit Card', 'EUR', 34.99, '2024-09-10');

INSERT INTO Orders.OrderItems (OrderId, GameId, OrderedAtPrice, ItemName)
VALUES
(1, 2, 49.99, 'Shadow Blades'),
(2, 1, 29.99, 'Cyber Drift'),
(3, 3, 19.99, 'Neon Skies'),
(4, 4, 14.99, 'Pixel Dungeon'),
(5, 5, 39.99, 'Samurai Rebirth'),
(6, 6, 24.99, 'Frozen Depths'),
(7, 7, 19.99, 'Dream Tides'),
(8, 8, 9.99, 'PixelPanda Park'),
(9, 9, 59.99, 'Code Breaker 2049'),
(10, 10, 34.99, 'Wolf Run');

INSERT INTO Reviews.Reviews (UserId, GameId, Rating, ReviewText)
VALUES
(1, 1, 9, 'Amazing racing experience with stunning visuals.'),
(2, 2, 8, 'Solid gameplay but could use better story pacing.'),
(3, 3, 7, 'Relaxing and fun, great background music.'),
(4, 4, 10, 'Classic dungeon nostalgia at its best.'),
(5, 5, 9, 'Beautiful sword fighting mechanics and visuals.'),
(6, 6, 8, 'Challenging survival mechanics and beautiful icy landscapes.'),
(7, 7, 9, 'Dreamy visuals and relaxing sea exploration.'),
(8, 8, 7, 'Cute and cozy, perfect for a short play session.'),
(9, 8, 10, 'I loved this game! The best one I have ever played.'),
(9, 9, 10, 'Incredible atmosphere and mind-bending puzzles.'),
(10, 10, 8, 'Fast, fun, and snowy chaos all around.');
