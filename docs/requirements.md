## **PRM393 – Mobile Programming** 

## **Lab2: Journal Trend Analysis Mobile Application** 

## **1. Introduction** 

Research publications are growing rapidly across many disciplines, making it increasingly important to identify emerging topics, influential papers, active researchers, and publication trends. Academic databases such as OpenAlex provide access to large-scale scholarly data that can be used for research analytics and decision support. 

In this assignment, students will develop a Flutter-based mobile application that retrieves publication data from OpenAlex and provides analytical insights through interactive visualizations and dashboards. The application should help users explore research trends for a selected topic and gain a better understanding of the corresponding research landscape. 

## **2. Learning Objectives** 

Upon successful completion of this assignment, students will be able to: 

- Develop cross-platform mobile applications using Flutter. 

- Integrate and consume RESTful APIs. 

- Process and analyze JSON data from external sources. 

- Implement asynchronous programming and state management. 

- Design user-friendly mobile interfaces. 

- Visualize analytical data using charts and dashboards. 

- Apply AI-assisted code review techniques to improve software quality. 

- Organize software projects using maintainable architecture and coding practices. 

## **3. Assignment Requirements** 

Students are required to develop a mobile application named **Journal Trend Analyzer** that uses the OpenAlex API as the primary data source. 

The application must allow users to search for a research topic and analyze the retrieved publication data. All data displayed in the application, including the list of searchable topics, must be retrieved dynamically from OpenAlex. The use of hard-coded datasets is not allowed. 

## **3.1 Out of Scope** 

To ensure that students focus on mobile application development, API integration, data visualization, and trend analysis, the following features are **explicitly excluded** from the scope of this assignment: 

- Developing custom backend services or REST APIs. 

- Implementing user authentication or authorization mechanisms (e.g., Firebase Auth, OAuth2). 

- User registration, login, password management, or role-based access control. 

- Database design and deployment. 

- Data persistence on cloud platforms. 

- Real-time data synchronization. 

- Push notifications. 

- Payment processing features. 

- Social networking features such as comments, likes, or sharing. 

- Administrative dashboards. 

- Machine learning model training or deployment. 

- Web application development. 

Students must use the OpenAlex API as the sole external data source for retrieving publication information and performing trend analysis. The application should consume OpenAlex data directly from the mobile client without introducing additional backend components. 

## **4. Functional Requirements** 

## **4.1 Topic Search** 

The application shall allow users to search for research publications by entering a topic keyword or selecting one from a dynamic list. Search results should display essential publication information, including the publication title, publication year, citation count, and journal name. 

## **4.2 Publication Details** 

The application shall provide a detailed view for each publication. The detail screen should include information such as publication title, authors, publication year, journal name, citation count, DOI, and abstract when available. 

## **4.3 Publication Trend Analysis** 

The application shall analyze publication activity over time by grouping publications according to publication year. The result must be visualized using a **Line Chart** (Publication Trend) to illustrate the growth or decline of the selected research topic. 

## **4.4 Top Influential Papers** 

The application shall identify and display the most influential publications based on citation counts. Publications should be ranked from highest to lowest citation count. 

## **4.5 Top Research Journals (Journal Ranking)** 

The application shall identify journals that contribute the largest number of publications related to the selected research topic. The result must be visualized using a **Horizontal Bar Chart** (Journal Ranking) to fit the theme of Journal Trend Analysis. 

## **4.6 Top Contributing Authors (Productivity vs Impact & Collaboration)** 

The application shall analyze author contribution and collaboration:
1. **Author Productivity vs Impact**: Must be visualized using a **Scatter Plot** showing higher analytical value than just top authors (plotting papers count vs citation count/impact).
2. **Author Collaboration**: Must be visualized using a **Network Graph** to represent academic collaboration networks, increasing visual appeal and academic depth.

## **4.7 Research Trend Dashboard** 

The application shall provide a dashboard summarizing key insights for the selected topic. The dashboard should include total publications, average citation count, most active publication year, top journal, top author, and most influential paper. 

## **4.8 Dynamic Research Topics (From API)** 

The application must not use any hardcoded research topics. Instead, it must retrieve research topics dynamically from the OpenAlex API. 

- **Topic Fetching**: Fetch available concepts/topics from the OpenAlex concepts endpoint (`https://api.openalex.org/concepts`). 
- **Interactive UI**: Display topics in a searchable dropdown or autocomplete field. 
- **Topic Support**: Support topics such as Natural Language Processing (NLP), Retrieval-Augmented Generation (RAG), Machine Learning, Data Science, Cybersecurity, Blockchain, IoT, and any other concepts returned by OpenAlex. 
- **Session Caching**: Cache the retrieved topic results during the current application session to avoid redundant API calls. 

## **4.9 User Customization & Personalization Setup** 

When users open the application for the first time, they shall complete a personalization setup screen. 

- **Required Fields**: 
  1. **Full Name**: The user's name. 
  2. **Research Interest**: Selected from the dynamic OpenAlex concepts list. 
- **Easter Egg Feature**: 
  - Provide a button labeled **"Generate Random Researcher Name"**. 
  - When clicked, it must dynamically generate a realistic researcher-style name (e.g., *Dr. Alan Quantum*, *Prof. Emma Neural*, *Dr. Sophia Vector*). 
  - The generated name must automatically populate the Full Name field. 
- **Local Preference Storage**: The application shall store these user preferences locally (e.g., using `shared_preferences` or a local key-value store) so the setup screen is bypassed on subsequent app launches. 

## **4.10 Personalized Analytics & Dashboard** 

The research dashboard must adapt dynamically based on the stored user customization data. 

- **Personalized Header Messages**: Display messages such as: 
  - `"Welcome back [Full Name]"` (e.g., *"Welcome back Dr. Alan Quantum"*) 
  - `"Latest trend insights for [Selected Research Interest]"` (e.g., *"Latest trend insights for Natural Language Processing"*) 
- **Automated Focus**: Charts and dashboard metrics must automatically filter and focus on the user's selected research interest by default upon entering the dashboard. 

## **4.11 Automatic Daily Data Refresh** 

To ensure analytical data is up-to-date without using a backend server, the application shall implement a local daily refresh mechanism. 

- **Sync Timestamp Logging**: Save the timestamp of the last successful data sync. 
- **Startup Sync Check**: On application startup, the application shall check the current device date: 
  - If the date has changed since the last successful sync (i.e., after 00:00 local device time has passed), the app must automatically fetch the latest OpenAlex data for the user's research interest, update the local cache, and refresh the analytics. 
- **Manual Refresh**: Provide an option for the user to manually trigger a data refresh. 
- **Last Updated Display**: Display the "last updated" timestamp on the dashboard to inform the user of the data currency. 

## **4.12 Top Keywords Analysis** 

The application shall identify and retrieve the top keywords associated with the selected research topic. The keywords analysis must be visualized using a **Horizontal Bar Chart** (Top Keywords) for readability, integrated into the Keywords tab. 

## **5. Technical Requirements** 

The application must be developed using Flutter and Dart. 

Students must implement API integration, asynchronous data retrieval, JSON processing, error handling, loading states, and data visualization. The project should follow a clean and maintainable structure with appropriate separation of concerns between user interface, business logic, and data access layers. 

At minimum, the project should contain dedicated modules or folders for **models, services, screens, widgets, and state management components.** 

Specific additions: 
- **No Backend Server**: The application must run entirely client-side and fetch data directly from the OpenAlex API. 
- **Local Persistence & Caching**: Implement a local persistence solution (e.g., `shared_preferences`, `Hive`, or `sqflite`) to store: 
  - User customization preferences (Full Name, Research Interest). 
  - Last sync timestamp. 
  - Cached analytical data for daily refresh comparison. 
- **Session Caching**: Keep a memory cache of the OpenAlex concepts to avoid fetching the topic list multiple times per session. 

The application must run successfully on Android devices and Android emulators. 

## **6. AI-Assisted Code Review** 

As part of the software quality assurance process, students are required to conduct an AI-assisted code review before submission. 

Students may use tools such as SonarQube, Kodus AI, CodeRabbit, or GitHub Copilot Code Review. 

The code review must identify at least three issues, warnings, code smells, bugs, security concerns, or improvement opportunities. Students should address the findings whenever appropriate and document the review process in the project report. 

Evidence of the review process must be provided through screenshots and brief explanations of the detected issues and implemented improvements. 

## **7. User Interface Requirements** 

The application shall use a bottom navigation bar containing **4 main tabs**:

- **Home**: Search Topic + Recent Searches 
- **Journal**: Publications + Details 
- **Keywords**: Trends + Authors + Journals 
- **Profile**: Settings/About 

*(Note: The **Personalization Setup Screen** is still required on the first-time launch before entering the main tabbed interface).*

### **Analytical Charts and Visualizations**
The application must contain the following **5 charts (diagram/display types)** corresponding to the analytical tasks:

| #  | Analysis                      | Display Type   | Lý do                                                   |
| -- | ----------------------------- | -------------- | ------------------------------------------------------- |
| 1  | Publication Trend             | Line Chart     | Bắt buộc để thể hiện xu hướng nghiên cứu theo thời gian |
| 3  | Top Keywords                  | Horizontal Bar | Dễ lấy dữ liệu, dễ hiểu, phù hợp tab Keywords           |
| 9  | Author Productivity vs Impact | Scatter Plot   | Thể hiện giá trị phân tích cao hơn chỉ Top Authors      |
| 14 | Journal Ranking               | Horizontal Bar | Phù hợp tên đề tài Journal Trend Analysis               |
| 18 | Author Collaboration          | Network Graph  | Biểu đồ mạng nổi bật, tăng tính trực quan và học thuật  |

The user interface should be responsive, visually consistent, and easy to navigate. 

## **8. Deliverables** 

## **8.1 Source Code** 

Students shall submit the complete source code through a GitHub repository named according to the following convention: 

PRM393_Lab2_StudentID 

The repository must contain all source files and any additional resources required to run the application. 

## **8.2 Project Report** 

Students shall submit a project report of approximately 5–10 pages in PDF format. 

The report should include the project overview, system design, implementation details, API integration approach (including OpenAlex Concept list integration and dynamic refresh logic), screenshots of major features (including the personalization setup and Easter egg features), trend analysis results, AI-assisted code review findings, challenges encountered, and lessons learned. 

