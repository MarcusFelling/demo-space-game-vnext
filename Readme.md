# Demo.SpaceGamevNext

The next iteration of Demo.SpaceGame, using containers and GitHub Actions.

The Space Game website is a .NET 5 app written in C# that's deployed to Azure Web App for Containers, and a SQL Server backend that's deployed to Azure SQL. The infrastructure is deployed using Bicep, and the application is tested using Selenium and JMeter.

# CI/CD

#TODO NEEDS UPDATES
[![Build Status] 

1. The main branch is set up with a [branch protection rule](https://docs.github.com/en/github/administering-a-repository/managing-a-branch-protection-rule#:~:text=You%20can%20create%20a%20branch,merged%20into%20the%20protected%20branch.) that requires [TailSpin.SpaceGame.Pipeline](https://github.com/MarcusFelling/Demo.SpaceGame/blob/main/TailSpin.SpaceGame.Pipeline.yml). This means the topic branch that is targeting main, will need to successfully make it through the entirety of the pipeline before the PR can be completed and merged into main.
2. The build stage of the pipeline ensures all projects successfully compile and unit tests pass. 
3. The pipeline will then add a comment to your PR with the URL to a new Azure Web App containing your changes, that can be used for exploratory testing or remote debugging.
4. Meanwhile, the pipeline will execute UI and load tests in a testing environment. 
5. If all tests are successful, the pipeline will wait for manual approval before deploying to production. 
6. After the production deployment is complete, a final stage will run to clean up the development environment, then the PR can be completed.

Note: If DB schema changes containing CREATE, ALTER, or DELETES are detected, a manual review will be required.

![image](https://user-images.githubusercontent.com/6855361/108082923-2c618480-7038-11eb-928c-0728610a8349.png)


