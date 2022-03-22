# S3 OAuth2 Authentication with Okta
This module provides OAuth2 authentication with Okta for an **existing** S3 bucket configured as static website.

The resources created by this module will be deployed in `us-east-1` because Lambda@Edge can only be deployed in this region (the Lambda is then replicated all over the world by AWS).

The Lambda is written in NodeJS because Lambda@Edge requires that the **Lambda package size, _including dependencies_, is at most 1 MB**. Other runtimes such as Python don't include as much features as NodeJS in their _standard library_ (at least for the specific features we need) and so the Lambda package would be too large with these runtimes.

**Be careful**, this module will put in place a **S3 bucket policy** for the existing S3 bucket, **if your bucket already have one it will be overwritten**.


## Deployment
A Terraform deployment example is provided in the `./aws-s3-oauth2-okta/example-deployment` folder.

### 1. Create the Okta application
Create the application with the correct **redirect URI** and retrieve the **client ID** and **client secret**.
  
### 2. Install NPM packages
Go to `./aws-s3-oauth2-okta/module/okta_auth_lambda_package` and run `npm install --only=prod`.

### 3. Apply!
We assume here that you have an AWS environment configured locally.

Go back to `./aws-s3-oauth2-okta/example-deployment` and run:
1. Initialize Terraform: `terraform init`
2. Apply:
```bash
TF_VAR_aws_account_id=${AWS_ACCOUNT_ID} \
TF_VAR_okta_client_id=${OKTA_CLIENT_ID} \
TF_VAR_okta_client_secret=${OKTA_CLIENT_SECRET} \
TF_VAR_okta_domain=${OKTA_DOMAIN} \
terraform apply
```

## How it works
The main building blocks of the solution are:
* A CloudFront distribution with a CloudFront Origin Access Identity (OAI)
* A Lambda@Edge

The bucket access is configured as **private** and so the only way to access it is via the **CloudFront OAI** which is allowed to read it thanks to an **S3 bucket policy**.

The CloudFront distribution has a **Lambda@Edge configured on the `viewer-request` event** (see image below). It means that every time a request is made, **it first goes through the Lambda** before reaching the Origin (the S3 bucket).

The Lambda will then decide what to do based on the **authentication Cookie** that the user submitted (or not) in the request. It will either:
* Redirect the user to Okta if there is no Cookie or if it is invalid/expired
* Display a `401 Unauthorized` response if Okta returned an invalid Auth Code
* Redirect the user to `/index.html` if the login was successful (i.e. Okta returned a valid Auth Code)
* Allow the request to continue to the Origin if the authentication Cookie is valid

Note: the authentication cookie actually contains a **signed JWT**, that's how the Lambda knows it is legit.

<div align="center"><img src="cloudfront-events-that-trigger-lambda-functions.png" alt="CloudFront events that trigger Lambda functions"/></div>
