# Material Inventory App

This project consists of a Rails API and an Angular front-end application to manage and display material inventory. The app is built to work together as a single system, where the Rails backend provides RESTful API endpoints consumed by the Angular frontend.

# Project Overview

The **Material Inventory Dashboard** is designed to handle inventory items for Vanilla Steel, allowing users to upload and search inventory data. The **Preference Matching Function** enables users to upload preferences and find matches from the inventory based on certain criteria.

The backend API is built using Ruby on Rails, while the frontend is built with Angular and styled using Google Material 3 design components.

# Table of Contents

1. [Material Inventory App](#material-inventory-app)
2. [Project Overview](#project-overview)
3. [Technology Stack](#technology-stack)
4. [Project Structure](#project-structure)
5. [API Endpoints](#api-endpoints)
6. [Setup and Running Locally](#setup-and-running-locally)
7. [Deploying to Fly.io](#deploying-to-flyio)
8. [Assignment Requirements Compliance](#assignment-requirements-compliance)
9. [Further Improvements & Assumptions](#further-improvements--assumptions)

## Technology Stack

- **Backend**: Ruby on Rails
- **Database**: SQLite
- **Frontend**: Angular
- **UI Framework**: Angular Material UI

## Project Structure

The repository is structured as follows:
```
material-inventory-rails-angular/
│
├── material-inventory-rails/ # Rails API application
├── material-inventory-dashboard-angular/ # Angular front-end application
├── docker-compose.yml # Docker Compose file to build both services
└── .gitignore # Gitignore file for the project
```


The application is deployed on [Fly.io](https://fly.io/) using Docker containers for both Rails and Angular apps.

## API Endpoints

Below is a list of available API endpoints provided by the Rails backend:

- **GET /api/v1/inventories?page=1&limit=2**
  Retrieves paginated inventory items.

- **POST /api/v1/inventories/upload**
  Uploads inventory data through a CSV file.

- **POST /api/v1/preferences/upload?page=1**
  Uploads preference data through a CSV file.

- **GET /api/v1/preferences**
  Retrieves preferences based on the uploaded preference data.

## Setup and Running Locally

To run both the Rails API and the Angular frontend locally, you need Docker and Docker Compose installed on your machine.

### Prerequisites

- **Docker**: Ensure Docker is installed and running.
- **Docker Compose**: Make sure you have Docker Compose available.

### Running the Application

1. **Clone the repository**:

    ```bash
    git clone git@github.com:manjarb/Rails-Angular-Material-Inventory-Dashboard.git
    cd material-inventory-rails-angular
    ```

2. **Set up environment variables**:

    Both `material-inventory-rails` and `material-inventory-dashboard-angular` have their respective environment variables.

3. **Build and run the Docker containers**:

    Use the Docker Compose file to build and run both services:

    ```bash
    docker-compose up --build
    ```

    This command will build the images and start both the Rails and Angular applications.

4. **Access the applications locally**:

   - **Rails API**: [http://localhost:4000](http://localhost:4000)
   - **Angular Frontend**: [http://localhost:4200](http://localhost:4200)

## Deploying to Fly.io

Both the Rails and Angular apps are deployed to [Fly.io](https://fly.io/) based on their respective Dockerfiles.

### Deploying Rails API

1. **Fly Configuration**: Make sure you have a `fly.toml` file in `material-inventory-rails`.
2. **Build and deploy**:

    ```bash
    cd material-inventory-rails
    flyctl deploy
    ```

### Deploying Angular Frontend

1. **Fly Configuration**: Make sure you have a `fly.toml` file in `material-inventory-dashboard-angular`.
2. **Build and deploy**:

    ```bash
    cd material-inventory-dashboard-angular
    flyctl deploy
    ```

---

If you encounter any issues during the deployment or setup, please check the Fly.io documentation or reach out to support.

## Assignment Requirements Compliance

This project fulfills all requirements as outlined in the coding challenge:

- **Data Persistence**: The Rails backend uses SQLite to persist inventory and preference data.
- **API Endpoints**: The API endpoints enable CRUD operations for inventory data and preferences.
- **Preference Matching**: The matching logic is implemented based on the specified criteria, including material, dimensions, and other attributes.
- **Frontend Interface**: The Angular frontend provides a user-friendly interface for managing inventory and preferences.
- **Deployment**: The project is deployed on Fly.io with the backend and frontend hosted as separate services.

## Further Improvements & Assumptions

### Further Improvements
1. **Inventory CRUD Operations**: Implement full Create, Read, Update, and Delete (CRUD) operations for inventory items, allowing users to manage inventory directly from the dashboard.
2. **Enhanced Inventory Search**: Add advanced filtering and searching capabilities on the inventory page to improve user experience.
3. **Preference Analytics & Insights**: Display analytical data and useful insights related to preferences, such as the most frequently matched items or missing items that could fulfill certain preferences.
4. **User Authentication & Roles**: Implement user authentication and role-based access control for better data security and personalized user experience.

### Assumptions
- **Environment-Specific CORS Rules**: Different environments (development, staging, production) may require different CORS settings, and they are configured accordingly.
- **SQLite for Simplicity**: SQLite is used as the database for its simplicity in setup and usage, though a more scalable solution may be required in a real production environment.
