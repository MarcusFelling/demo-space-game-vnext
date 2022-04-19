# demo-space-game-vnext

![spaceGame](https://user-images.githubusercontent.com/6855361/111529516-3efed480-8730-11eb-9a73-a1f4727f3b21.PNG)

The next iteration of [demo-space-game](https://github.com/MarcusFelling/Demo.SpaceGame), now using containers and GitHub Actions 🚀!

The Space Game website is a .NET 5 web app that's deployed to ☁️ Azure Web App for Containers and Azure SQL ☁️. The infrastructure is deployed using [Azure Bicep](https://github.com/Azure/bicep) 💪, and the application is tested using [Playwright](https://playwright.dev/) for browser tests and [Azure Load Testing](https://azure.microsoft.com/services/load-testing/) for load tests.

## CI/CD Workflow

![Main branch](https://github.com/MarcusFelling/demo-space-game-vnext/actions/workflows/pipeline.yml/badge.svg?branch=main)

The main branch is set up with a [branch protection rule](https://docs.github.com/en/github/administering-a-repository/managing-a-branch-protection-rule#:~:text=You%20can%20create%20a%20branch,merged%20into%20the%20protected%20branch.) that require all of the jobs in the [pipeline](https://github.com/MarcusFelling/demo-space-game-vnext/actions/workflows/pipeline.yml) succeed. This means the topic branch that is targeting main will need to make it through the entirety of the pipeline before the PR can be completed and merged into main.

1. The build stage of the pipeline ensures all projects successfully compile and unit tests pass.
1. The pipeline will provision a new website for your branch (branch name will be in URL), that can be used for exploratory testing or remote debugging. The URL of the new website will post to the Environments section of the PR. Click "View Deployment" to open the site:
![environment](https://user-images.githubusercontent.com/6855361/111533320-a61e8800-8734-11eb-93d4-b2f4883313b3.PNG)
1. Meanwhile, the pipeline will execute functional and load tests in a testing environment.
1. If all tests are successful, the pipeline will deploy to production.
1. After the PR is merged, a final [workflow](https://github.com/MarcusFelling/demo-space-game-vnext/blob/main/.github/workflows/cleanup.yml) will run to clean up the development environment.

![image](https://user-images.githubusercontent.com/6855361/162650030-869aea0c-b666-4454-9c02-35e0f0221408.png)

