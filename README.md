# Azure Container Apps Template

This repo contains the code required to create, deploy, and keep maintained an Azure container apps environment with a connected frontend & backend.

## Infrastructure

All infrastructure is deployed using terraform. It deploys the following resources:
  - Container app environment
  - Backend container app with no external traffic allowed
    - Container is pulled from GHCR from your user/repo
  - Frontend container app with external traffic allowed
    - Container is pulled from GHCR from your user/repo 
    - Also includes a backend_endpoint env variable for internal communication
   
## Backend

- Standard FastAPI server with a single test endpoint as a template
- Dockerfile to package up the server with UV to handle dependencies

## Frontend

- Simple Streamlit webpage with a call to the backend to test the page is working
- Dockerfile to package up the server with UV to handle dependencies

## CI/CD

Three github actions workflows to handle infrastructure creation, and repackaging & deployment of the front and backend.
