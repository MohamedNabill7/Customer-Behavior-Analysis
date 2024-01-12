# Customer-Behavior-Analysis
Analyzing own data of an online learning platform to understand how students learn and engage on the platform. Create some dashboards in Tableau including KPIs.

### Objective
1. Give a student the best learning experience. It would happen if we had complete control of the entire user journey
2. Learn how students interact with products

### Business Case

we live in a competitive environment with an abundance of choices if a customer is unsatisfied with a product and doesn’t find it straightforward. It could be easy to find an alternative solution. Customers who engage with a product to a greater extent are more likely to stay loyal for a more extended period, especially regarding subscription services.

**Terminology** 
1. Engagement: Begining one of the following activities a lecture from a course, quiz, or exam
2. Onboarding: First-time Engagement
3. Student Type: Free Plan Student or Paying Student

**Key Questions**
1. How engaged are the students inside the platform, and how can this metric be improved?
2. How long do students stay engaged on the platform, and how can this period be extended?
3. What’s the difference between free and paid students?
4. Which are the most popular courses on the platform?
5. How many students sit for an exam?
6. Is Engagement changing with time?
7. Marketing campaign effects?
8. Onboard students / Registered students? Refers to students who found the platform intuitive 
9. Average minutes watched by students? And the difference between free and paid students?
10. What is the free-to-paid conversion rate? Based on the minutes watched 
11. Most watched and enjoyed the course on the platform:
    • Total minutes watched
    • Average minutes watched 
    • Completion rate

### First Dashboard **Overview**

Display overall engagement with the product including:
1. **Three Key Performance Indicators (KPIs):** 
    * Number of engaged students
    * Minutes watched per student
    * Number of certificates issued

with filters include the status of the student and specify which date to see the KPIs

2. **Horizontal Chart:** Each bar corresponds to a course and represents the following metrics

* Overall Minutes Watched:
    Filter to show the top five courses based on minutes watched.
    Filter to show the bottom five courses based on minutes watched.
* Minutes Watched per Student:
    Filter to show the top five courses based on minutes watched per student.
    Filter to show the bottom five courses based on minutes watched per student.
* Completion Rate:
    Filter to show the top five courses based on completion rate.
    Filter to show the bottom five courses based on completion rate.

3. **Donut Chart:** A center represents the average rating of a platform


### Secnod Dashboard **Engagement and Onboarding**

1. Top Part - Line Chart: Number of Engaged Students vs. Time

* Filter Options:
    Users can filter between Free Plan and Paying Plan.
    Allow users to select a custom time period.
* Line Chart:
    X-axis represents time (date or time period).
    Y-axis represents the number of engaged students.

2. Bottom Part - Line Chart: Percentage of Onboarded Students vs. Date of Registration

* Filter Options:
    Users can choose the period themselves.
    Users can select a custom time period.
* Line Chart:
    X-axis represents the date of registration.
    Y-axis represents the percentage of onboarded students.

Create three navigate buttons that show different Views:

First View: `User-Selected Period`:
    Users can choose the start and end dates for the period they are interested in.

Second View: `Monthly Split - User Chooses a Month`:
    Users select a specific month, and the line chart adjusts to show data for that month.

Third View: `Monthly Bar Chart`:
    Data is aggregated on a monthly basis.
