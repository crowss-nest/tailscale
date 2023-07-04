#!/bin/bash

# Get device IDs
device_ids=$(tailscale status --json | jq -r '.Peer | to_entries[] | select(.value.HostName | contains("github-fv")) | .value.ID')

# Iterate over device IDs and delete each device
for device_id in $device_ids; do
  # Delete device
  response=$(curl -s -X DELETE "https://api.tailscale.com/api/v2/device/$device_id" -u "tskey-api-k82dpM3CNTRL-Gkzit4U5uLQVVS1xyk1oLQwH2V3jBeTpN:")
  if [[ $response == *"cannot delete devices outside of your tailnet"* ]]; then
    echo "Cannot delete device $device_id: Device does not belong to your tailnet"
  else
    echo "Deleted device $device_id"
  fi
done
