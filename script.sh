#!/bin/bash

# Set AWS access keys and secret access keys
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
aws_region=us-east-1

# Get all parameter names from SSM Parameter Store in the specified region
parameter_names=$(aws ssm describe-parameters --region "$aws_region" --query "Parameters[*].Name" --output text)

# Check if any parameters were retrieved
if [[ -z "$parameter_names" ]]; then
    echo "No parameters found in SSM Parameter Store."
    exit 1
fi

# Loop through each parameter and fetch its value
for parameter_name in $parameter_names; do
    echo "Fetching value for parameter: $parameter_name"
    # Get the value of the parameter
    parameter_value=$(aws ssm get-parameter --region "$aws_region" --name "$parameter_name" --query "Parameter.Value" --with-decryption --output text)

    # Extract variable name from parameter name
    variable_name=$(basename "$parameter_name")

    # Check if the value was retrieved successfully
    if [[ -n "$parameter_value" ]]; then
    # Append variable and its value to .env file
    echo "$variable_name=$parameter_value" >> .env
    else
        echo "Failed to fetch value for parameter: $parameter_name"
    fi

done

# Check if .env file was created
if [[ -f .env ]]; then
    echo ".env file created successfully."
else
    echo "Failed to create .env file."
fi


