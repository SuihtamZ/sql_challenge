--1
SELECT DisplayName, Location, Reputation
FROM Users
ORDER BY Reputation DESC;

--2
SELECT Posts.Title, Users.DisplayName
FROM Posts
INNER JOIN Users ON Posts.OwnerUserId = Users.Id
WHERE Posts.OwnerUserId IS NOT NULL AND Posts.Title IS NOT NULL
ORDER BY Users.DisplayName ASC;

--3
SELECT Users.DisplayName, AVG(Posts.Score) AS Promedio
FROM Posts
INNER JOIN Users ON Posts.OwnerUserId = Users.Id
WHERE Posts.OwnerUserId IS NOT NULL
GROUP BY Users.DisplayName
ORDER BY Promedio DESC; -- Ordena los resultados por el promedio de Score en orden descendente

--4
SELECT Users.DisplayName
FROM Users
WHERE Users.Id IN (
    SELECT Comments.UserId
    FROM Comments
    GROUP BY Comments.UserId
    HAVING COUNT(Comments.Id) > 100
)
ORDER BY Users.DisplayName ASC;

--5
UPDATE Users
SET Location = 'Desconocido'
WHERE Location IS NULL OR Location = '';

PRINT 'Se  actualizaron correctamente todas las ubicaciones';

--6
DECLARE @Contador INT;

-- Crear una tabla temporal para almacenar los IDs de los comentarios eliminados
CREATE TABLE #ComentariosB (ComentID INT);


DELETE FROM Comments
OUTPUT DELETED.Id INTO #ComentariosB(ComentID)
WHERE UserId IN (
   SELECT Id
   FROM Users
   WHERE Reputation < 100
);

SELECT @Contador = COUNT(*) FROM #ComentariosB;

-- Imprime el mensaje con el número de comentarios eliminados
PRINT 'El total de comentarios borrados fue de: ' + CAST(@Contador AS VARCHAR);

--7
SELECT 
    Users.DisplayName,
    ISNULL(Posts.TotalPosts, 0) AS TotalPosts,
    ISNULL(Comments.TotalComments, 0) AS TotalComments,
    ISNULL(Badges.TotalBadges, 0) AS TotalBadges
FROM 
    Users
LEFT JOIN 
    (SELECT OwnerUserId, COUNT(*) AS TotalPosts
     FROM Posts
     GROUP BY OwnerUserId) AS Posts ON Users.Id = Posts.OwnerUserId
LEFT JOIN 
    (SELECT UserId, COUNT(*) AS TotalComments
     FROM Comments
     GROUP BY UserId) AS Comments ON Users.Id = Comments.UserId
LEFT JOIN 
    (SELECT UserId, COUNT(*) AS TotalBadges
     FROM Badges
     GROUP BY UserId) AS Badges ON Users.Id = Badges.UserId
ORDER BY 
    Users.DisplayName;

--8
SELECT 
    Title,
    Score
FROM 
    Posts
ORDER BY 
    Score DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

--9
SELECT 
    Text,
    CreationDate
FROM 
    Comments
ORDER BY 
    CreationDate DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;