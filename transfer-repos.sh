#!/bin/bash

####################
###### CONFIG ######
####################
repos=(
    'some-repo'
)
team_id=xyz

from_user="some-user"
to_user="some-other-user"
####################

####################
###### LOGIC #######
####################
check="\xE2\x9C\x94"
cross="\U274C"

prefixes=()
suffixes=()

for i in ${!repos[@]}
do
    prefixes+=(" ")
    suffixes+=(" ")
done

function print_title() {
    echo "--------------------"
    echo "| GH Repo Transfer |"
    echo "--------------------"
    echo "$from_user -> $to_user"
}

function print_repos() {
    echo ""
    echo "Transferring repos"
    echo "--------------------"
    for j in ${!repos[@]}
    do
        repo_name=${repos[$j]}
        prefix=${prefixes[$j]}
        suffix=${suffixes[$j]}
        echo -e "$prefix $repo_name $suffix"
    done
    echo "--------------------"
}

function print_status() {
    print_title
    print_repos
}

clear
print_status

# Get the password from the repo owner
echo -n "Enter your github password: "
read  pass

# set the fix repo to loading
suffixes[0]="..."

for i in ${!repos[@]}
do
    clear
    repo="${repos[$i]}"
    print_status
    echo -n "transfering $repo from $from_user to $to_user"
    
    transfer_url="https://api.github.com/repos/$from_user/$repo/transfer"
    transfer_data="{\"new_owner\": \"$to_user\", \"team_ids\": [$team_id]}"
    accept_header="Accept: application/vnd.github.nightshade-preview+json"
    credentials="$from_user:$pass"

    result=$(curl -i -s -u "$credentials" $transfer_url -d "$transfer_data" -H "$accept_header")

    echo "${result[@]}"

    # extract the status code header from the response
    status="$(echo "${result[@]}" | grep Status)"

    # update the status icons
    suffixes[$i]=" "
    suffixes[$i+1]="..."

    # look for a 2xx status code to indicate success
    if [[ "$status" == *"2"* ]]
    then
        prefixes[$i]="$check"
    else
        prefixes[$i]="$cross"
    fi
done

# print a final status message
clear
print_status
