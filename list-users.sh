#!bin/bash

###################
# About: list the users with read access
# Input: USERNAME , TOKEN
#
#
# Owner: Anuradha Raj
#########################

helper()

# Github API URL 
API_URL="https://api.github.com"

# Github username and personal access tokaen
USERNAME=$username
TOKEN=$token

# User and Repository Information
REPO_OWNER=$1
REPO_NAME=$2

# Function to make a GET request to the GitHub API
function github_api_get {
	local endpoint="$1"
	local url="${API_URL}/${endpoint}"

	# Send a GET request to the GitHub API with authentication
	curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
	  local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

	  #Fetch the list of collaborators on the repository
	  collaborators="${github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login'}"

	  #Display the list of Collaborators on the repository
	  if[[ -z "$collaborators"]]; then
		  echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
	  else 
		  echo "users with read access to ${REPO_OWNER}/${REPO_NAME}:"
		  echo "$collaborators"
	   fi
   }

function helper {
	expected_cmd_args=2

	if [ $# -ne $expected_cmd_args ]; then 
		echo "Please execute the script required cmd args"
		echo "Please enter REPO_OWNER and REPO_NAME"
	}

   # Main script

   echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
   list_users_with_read_access


