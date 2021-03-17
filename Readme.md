# Demo.SpaceGamevNext

The next iteration of [Demo.SpaceGame[(https://github.com/MarcusFelling/Demo.SpaceGame)], now using containers and GitHub Actions!

The Space Game website is a .NET 5 web app written in C# that's deployed to Azure Web App for Containers, and a SQL Server backend that's deployed to Azure SQL. The infrastructure is deployed using [Project Bicep](https://github.com/Azure/bicep), and the application is tested using Selenium for functional tests and JMeter for load tests.

# CI/CD Workflow

TODO: Add build status

1. The main branch is set up with a [branch protection rule](https://docs.github.com/en/github/administering-a-repository/managing-a-branch-protection-rule#:~:text=You%20can%20create%20a%20branch,merged%20into%20the%20protected%20branch.) that requires all of the jobs in the [pipeline](https://github.com/MarcusFelling/Demo.SpaceGamevNext/actions/workflows/pipeline.yml) to complete successfully. This means the topic branch that is targeting main, will need to successfully make it through the entirety of the pipeline before the PR can be completed and merged into main.
2. The build stage of the pipeline ensures all projects successfully compile and unit tests pass.
3. The pipeline will provision a new website for your branch, that can be used for exploratory testing or remote debugging. The URL of the new website will post to the Environments section of the PR: TODO
4. Meanwhile, the pipeline will execute functional and load tests in a testing environment.
5. If all tests are successful, the pipeline will wait for manual approval before deploying to production.
6. After the production deployment is complete, a final stage will run to clean up the development environment, then the PR can be completed.

TODO: Add image
