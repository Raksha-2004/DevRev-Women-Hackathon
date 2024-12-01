#!/bin/bash

# Step 1: Fetch Open Tickets
echo "Fetching open tickets..."
tickets=$(devrev ticket list --status=open --output=json)

# Step 2: Analyze Each Ticket
echo "$tickets" | jq -c '.[]' | while read -r ticket; do
    # Extract Ticket Details
    ticket_id=$(echo "$ticket" | jq -r '.id')
    ticket_title=$(echo "$ticket" | jq -r '.title')
    ticket_description=$(echo "$ticket" | jq -r '.description')

    # Tagging Logic
    tag="other" # Default tag
    if [[ "$ticket_description" == *"error"* || "$ticket_description" == *"failure"* || "$ticket_description" == *"doesn't work"* ]]; then
        tag="bug"
    elif [[ "$ticket_description" == *"add"* || "$ticket_title" == *"new"* || "$ticket_description" == *"enhance"* ]]; then
        tag="feature request"
    fi

    # Step 3: Apply Tag to Ticket
    echo "Updating ticket $ticket_id with tag: $tag"
    devrev ticket update "$ticket_id" --add-tags="$tag"
done

echo "All tickets processed and tagged."  this should be written where in windows