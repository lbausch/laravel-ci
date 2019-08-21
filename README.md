# laravel-ci: A Docker image for Continuous Integration

## Features
+ PHP 7.3
+ Composer
+ Node.js 10
+ npm 6.5
+ Yarn
+ Supports Laravel Dusk

## Examples
### Laravel Bitbucket Pipelines

An working example for PHPUnit & Laravel Dusk tests with Bitbucket Pipelines.

*Steps*
- Copy bitbucket-pipelines.yml to your project 
- Copy .env.bitbucket to your project
- Adjust .env.bitbucket according your setup variables
- Enyoy Bitbucket-Pipelines