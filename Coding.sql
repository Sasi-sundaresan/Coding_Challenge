--1. Provide a SQL script that initializes the database for the Job Board scenario “CareerHub"
CREATE DATABASE carrerhubs
USE Carrerhubs

--2. Create tables for Companies, Jobs, Applicants and Applications. 
--3. Define appropriate primary keys, foreign keys, and constraints. 
CREATE TABLE Companies(
companyID INT PRIMARY KEY,
CompanyName VARCHAR(50),
[Location] VARCHAR(50) )


CREATE TABLE Jobs(
JobID INT PRIMARY Key,
companyID INT 
FOREIGN KEY(companyID) REFERENCES Companies(companyID),
job_title VARCHAR(50) ,
jobDescription TEXT,
jobLocation VARCHAR(50),
salary DECIMAL,
jobType VARCHAR(50) CHECK(jobType IN('Fulltime','Parttime','Contracts')),
postDate DATETIME
)

CREATE TABLE Applicants(
ApplicantID INT PRIMARY KEY, 
FirstName VARCHAR(50),
LastName VARCHAR(50),
Email VARCHAR(50),
Phone BIGINT,
[Resume] TEXT
)



CREATE TABLE Applications(
ApplicationID INT PRIMARY KEY,
JobID INT,
FOREIGN KEY(JobID) REFERENCES Jobs(JobID),
ApplicantID INT
FOREIGN KEY(ApplicantID) REFERENCES Applicants(ApplicantID),
ApplicationDate DATETIME,
CoverLetter TEXT
)

INSERT INTO Companies (companyID, CompanyName, Location)
VALUES 
(1, 'TechSolutions', 'Chennai'),
(2, 'Innovative Ideas', 'Coimbatore'),
(3, 'SmartTech', 'Madurai'),
(4, 'NextGen Software', 'Trichy'),
(5, 'Creative Minds', 'Salem');


INSERT INTO Jobs 
VALUES 
(1, 1, 'Software Developer', 'Develop software applications and systems.', 'Chennai', 50000.00, 'Fulltime', '2024-10-01'),
(2, 2, 'Data Analyst', 'Analyze data to drive business decisions.', 'Coimbatore', 45000.00, 'Fulltime', '2024-09-15'),
(3, 3, 'Web Developer', 'Create and manage websites for clients.', 'Madurai', 40000.00, 'Parttime', '2024-08-20'),
(4, 4, 'UI/UX Designer', 'Design user interfaces for web and mobile apps.', 'Trichy', 38000.00, 'Fulltime', '2024-10-10'),
(5, 5, 'Marketing Specialist', 'Create marketing campaigns and strategies.', 'Salem', 42000.00, 'Fulltime', '2024-07-30');

INSERT INTO Applicants 
VALUES 
(1, 'Sam', 'Ravi', 'sam.ravi@email.com', 9876543210, 'Experienced software developer with 5 years of experience in building scalable web applications. Proficient in Java, Python, and cloud technologies.'),
(2, 'Ram', 'Krishnan', 'ram.krishnan@email.com', 8765432109, 'Creative graphic designer with 3 years of experience in digital marketing, specializing in brand design and user interface'),
(3, 'Shruthi', 'Nair', 'shruthi.nair@email.com', 7654321098, 'Data analyst with 4 years of experience in analyzing large datasets. Skilled in SQL, Python, and data visualization tools like Tableau.'),
(4, 'Karthik', 'Subramanian', 'karthik.subramanian@email.com', 6543210987, 'HR professional with 6 years of experience in talent acquisition, employee relations, and performance management'),
(5, 'Anjali', 'Reddy', 'anjali.reddy@email.com', 5432109876, 'Highly motivated marketing executive with 3 years of experience in social media campaigns and email marketing strategies.');

INSERT INTO Applications 
VALUES 
(1, 1, 1, '2024-10-02', 'I am excited to apply for the Software Developer position at TechSolutions.'),
(2, 2, 2, '2024-09-16', 'I am very interested in the Data Analyst role at Innovative Ideas.'),
(3, 3, 3, '2024-08-21', 'I believe my skills are a perfect fit for the Web Developer role at SmartTech.'),
(4, 4, 4, '2024-10-11', 'I would love to work as a UI/UX Designer at NextGen Software.'),
(5, 5, 5, '2024-08-01', 'I am passionate about marketing and would love to contribute at Creative Minds.');




--4. Ensure the script handles potential errors, such as if the database or tables already exist
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'careerhubs')
BEGIN
    CREATE DATABASE CareerHub;
END




--5. Write an SQL query to count the number of applications received for each job listing in the  "Jobs" table. Display the job title and the corresponding application count. Ensure that it lists all  jobs, even if they have no applications.

SELECT J.job_title,
COUNT(A.ApplicationID) AS ApplicationCount
FROM Jobs J
LEFT JOIN Applications A
ON J.JobID = A.JobID
GROUP BY J.job_title


--6.. Develop an SQL query that retrieves job listings from the "Jobs" table within a specified salary  range. Allow parameters for the minimum and maximum salary values. Display the job title, company name, location, and salary for each matching job.
DECLARE @MinSalary DECIMAL(10,2) = 40000;  
DECLARE @MaxSalary DECIMAL(10,2) = 80000;

SELECT J.job_title,C.CompanyName,J.jobLocation,J.salary
FROM Jobs J
JOIN Companies C ON J.companyID = C.companyID
WHERE  J.salary BETWEEN @MinSalary AND @MaxSalary





--7. Write an SQL query that retrieves the job application history for a specific applicant. Allow a  parameter for the ApplicantID, and return a result set with the job titles, company names, and  application dates for all the jobs the applicant has applied to.
SELECT J.job_title, C.CompanyName, A.ApplicationDate
FROM  Applications A
JOIN Jobs J ON A.JobID = J.JobID
JOIN Companies C ON J.companyID = C.companyID
WHERE A.ApplicantID =1
ORDER BY A.ApplicationDate DESC


--8.. Create an SQL query that calculates and displays the average salary offered by all companies for job listings in the "Jobs" table. Ensure that the query filters out jobs with a salary of zero
SELECT AVG(salary) AS Averagesalary
FROM Jobs 
WHERE salary>0

--9. Write an SQL query to identify the company that has posted the most job listings. Display the company name along with the count of job listings they have posted. Handle ties if multiple  companies have the same maximum count.SELECT TOP 1 WITH TIES C.CompanyName,
COUNT(J.JobID) AS JobCount
FROM Companies C
JOIN Jobs J ON C.companyID = J.companyID
GROUP BY C.CompanyName
ORDER BY JobCount DESC

--10. Find the applicants who have applied for positions in companies located in 'CityX' and have at least 3 years of experience.
ALTER TABLE Applications
ADD Experience INT


UPDATE Applications
SET Experience = 5
WHERE ApplicantID = 1

UPDATE Applications
SET Experience = 3
WHERE ApplicantID = 2 

UPDATE Applications
SET Experience = 4
WHERE ApplicantID = 3 

UPDATE Applications
SET Experience = 6
WHERE ApplicantID = 4 

UPDATE Applications
SET Experience = 3
WHERE ApplicantID = 5 


SELECT A.ApplicantID,A.FirstName,A.LastName,A.Email,A.Phone,Ap.Experience
FROM Applicants A
JOIN  Applications Ap ON A.ApplicantID = Ap.ApplicantID
JOIN Jobs J ON Ap.JobID = J.JobID
JOIN Companies C ON J.companyID = C.companyID
WHERE C.Location = 'Chennai'  AND Ap.Experience >= 1  

SELECT * from Applications


--11. Retrieve a list of distinct job titles with salaries between $60,000 and $80,000.

SELECT DISTINCT job_title
FROM Jobs
WHERE salary BETWEEN 30000 AND 80000

--12. Find the jobs that have not received any applications.

SELECT J.JobID, J.job_title
FROM Jobs J
LEFT JOIN Applications A ON J.JobID = A.JobID
WHERE A.ApplicationID IS NULL

--13. Retrieve a list of job applicants along with the companies they have applied to and the positions  they have applied for

SELECT A.FirstName,C.CompanyName,J.job_title
FROM Applicants A
JOIN Applications Ap ON A.ApplicantID = Ap.ApplicantID
JOIN Jobs J ON Ap.JobID = J.JobID
JOIN Companies C ON J.companyID = C.companyID

--14. Retrieve a list of companies along with the count of jobs they have posted, even if they have not received any applications

SELECT C.CompanyName,COUNT(J.JobID) AS JobCount
FROM Companies C
LEFT JOIN Jobs J ON C.companyID = J.companyID
GROUP BY C.CompanyName

--15. List all applicants along with the companies and positions they have applied for, including those who have not applied.

SELECT A.FirstName, C.CompanyName,J.job_title
FROM Applicants A
LEFT JOIN Applications Ap ON A.ApplicantID = Ap.ApplicantID
LEFT JOIN  Jobs J ON Ap.JobID = J.JobID
LEFT JOIN Companies C ON J.companyID = C.companyID


--16. Find companies that have posted jobs with a salary higher than the average salary of all jobs.SELECT C.CompanyName
FROM Companies C
JOIN Jobs J ON C.companyID = J.companyID
WHERE J.salary > (SELECT AVG(salary) FROM Jobs WHERE salary > 0)

--17. Display a list of applicants with their names and a concatenated job name and location
SELECT A.ApplicantID,A.FirstName,A.LastName,
CONCAT(J.job_title, ' - ', J.jobLocation) AS JobNameLocation
FROM Applicants A
LEFT JOIN Applications Ap ON A.ApplicantID = Ap.ApplicantID
LEFT JOIN Jobs J ON Ap.JobID = J.JobID



--18. Retrieve a list of jobs with titles containing either 'Developer' or 'Engineer'.

SELECT J.JobID,J.job_title,J.jobLocation,J.salary
FROM Jobs J
WHERE J.job_title LIKE '%Developer%' OR J.job_title LIKE '%Engineer%'

--19 Retrieve a list of applicants and the jobs they have applied for, including those who have not applied and jobs without applicants.

SELECT  A.FirstName,J.job_title, J.jobLocation
FROM Applicants A
LEFT JOIN Applications Ap ON A.ApplicantID = Ap.ApplicantID
LEFT JOIN Jobs J ON Ap.JobID = J.JobID


--20. List all combinations of applicants and companies where the company is in a specific city and the applicant has more than 2 years of experience. For example: city=Chennai
SELECT  A.ApplicantID,A.FirstName, A.LastName,C.CompanyName,C.Location AS CompanyLocation,J.job_title,Ap.Experience
FROM Applicants A
JOIN Applications Ap ON A.ApplicantID = Ap.ApplicantID
JOIN Jobs J ON Ap.JobID = J.JobID
JOIN Companies C ON J.companyID = C.companyID
WHERE C.Location = 'Chennai'  AND Ap.Experience > 2
