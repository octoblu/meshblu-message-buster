aws cloudwatch put-metric-data \
  --namespace "Linux System" \
  --metric-name "MessageBuster" \
  --unit "Count" \
  --value $1
