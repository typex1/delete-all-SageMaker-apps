#!/bin/bash
# original source: https://gist.githubusercontent.com/ojacques/7992f17d6a32afd9dabbd3526f305bf4/raw/631712ed8fb5192b384198dcbde12949a0fc7b04/aws-sagemaker-delete-apps.sh
set -x

# Itereate over all SageMaker KernelGatway, JuypterServer and Canvas apps, and delete them, in a specific Region

AWS_REGION=us-west-2

aws sagemaker list-apps --query "Apps[?AppType=='KernelGateway' && Status=='InService']" --region $AWS_REGION \
  | jq -r '.[] | "\(.AppName) \(.DomainId) \(.UserProfileName)"' \
  | while read AppName DomainId UserProfileName; do echo Deleting $AppName for user $UserProfileName ... && aws sagemaker delete-app --domain-id $DomainId --app-type KernelGateway --app-name $AppName --user-profile $UserProfileName --region $AWS_REGION; done

aws sagemaker list-apps --query "Apps[?AppType=='JupyterServer' && Status=='InService']" --region $AWS_REGION \
  | jq -r '.[] | "\(.AppName) \(.DomainId) \(.UserProfileName)"' \
  | while read AppName DomainId UserProfileName; do echo Deleting $AppName for user $UserProfileName ... && aws sagemaker delete-app --domain-id $DomainId --app-type JupyterServer --app-name $AppName --user-profile $UserProfileName --region $AWS_REGION; done

aws sagemaker list-apps --query "Apps[?AppType=='Canvas' && Status=='InService']" --region $AWS_REGION \
  | jq -r '.[] | "\(.AppName) \(.DomainId) \(.UserProfileName)"' \
  | while read AppName DomainId UserProfileName; do echo Deleting $AppName for user $UserProfileName ... && aws sagemaker delete-app --domain-id $DomainId --app-type Canvas --app-name $AppName --user-profile $UserProfileName --region $AWS_REGION; done
