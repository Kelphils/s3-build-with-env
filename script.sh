#!/bin/bash

# Set AWS access keys and secret access keys
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
aws_region=us-east-1

# Get all parameter names from SSM Parameter Store in the specified region
parameter_names=$(aws ssm describe-parameters --region "$aws_region" --query "Parameters[*].Name" --output text)

# Loop through each parameter and fetch its value
for parameter_name in $parameter_names; do
    # Get the value of the parameter
    parameter_value=$(aws ssm get-parameter --region "$aws_region" --name "$parameter_name" --query "Parameter.Value" --with-decryption --output text)

    # Remove leading '/' from parameter name to use as variable name
    variable_name=$(echo "$parameter_name" | awk -F'/' '{print $NF}')

    # Append variable and its value to .env file without surrounding them with quotes
    echo "$variable_name=$parameter_value" >> .env
done
