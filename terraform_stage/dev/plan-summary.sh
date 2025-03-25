#!/bin/bash

set -e

PLAN_FILE="tfplan.binary"

echo "🔍 Running terraform plan..."
terraform plan -out=$PLAN_FILE -compact-warnings

echo ""
echo "📦 Summary of planned changes:"
terraform show -json $PLAN_FILE | jq '
  .resource_changes[] 
  | select(.change.actions != ["no-op"]) 
  | {
      address: .address,
      actions: .change.actions
    }
'