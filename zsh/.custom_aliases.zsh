alias ssh_ami='ssh -i ~/.ssh/NotebookServer.pem ubuntu@amihai-ds-notebook.voyantis.co'
alias ip='curl ifconfig.me'
alias l='exa -lah  --no-user --icons --group-directories-first'
alias instances='bat ~/extra/aws_instances'
alias bc='bat ~/byobu_cheat_sheet'
alias v='vim'
alias cache='cd /Users/amihaio/Documents/work/cache'
alias b='bpytop'
alias lz='lazygit'
# alias ssh='kitty +kitten ssh'
alias aws_batch_checker='python3 ~/Documents/work/aws_batch_status_checker/aws-batch-job-status-checker.py'
alias gen_shortcuts='glow ~/dotfiles/extra/general_shortcuts.md'


add_batch_job(){
    local arg1="$1"
    local arg2="$2"

    local file="/Users/amihaio/Documents/work/aws_batch_status_checker/jobs.txt" 

    echo "$arg1 $arg2" >> "$file"

}

voyantis_env_vars(){
    export AWS_DEFAULT_REGION=us-east-1
    export PYTHONPATH=src
    export ENV_NAME=prod
    export APP_NAME=dummy
    export VOYANTIS_LOGGER_DISABLE_ES=1
    export VY_COMMON_LOGGER_DISABLE_ES=1
}


file_watch(){
	watch -n 0.2 cat $1
}

fp(){
  readlink -f $1
}

lsg(){
l | grep $1
}

lt(){
 exa -lahT -L $1  --icons --no-user --group-directories-first
}

print_csv(){
 column -s, -t < $1 | less -#5 -N -S    
}


dbt_run() {
    # Display help message
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "Usage: dbt_run -m <model_name> -c <customer> -p <product> -v <version> [-e <extra_args>] [-s <start_date>] [-d <end_date>]"
        return 0
    fi

    # Initialize variables
    local model2run=""
    local customer=""
    local product=""
    local norm_version=""
    local extra_args=""
    local landing_start_date=""
    local landing_end_date=""

    # Parse named options
    while getopts ":m:c:p:v:e:s:d:" opt; do
        case $opt in
            m) model2run="$OPTARG" ;;
            c) customer=$(echo "$OPTARG" | tr '[:lower:]' '[:upper:]') ;;
            p) product=$(echo "$OPTARG" | tr '[:lower:]' '[:upper:]') ;;
            v) norm_version="$OPTARG" ;;
            e) extra_args="$OPTARG" ;;
            s) landing_start_date="$OPTARG" ;;
            d) landing_end_date="$OPTARG" ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                return 1
                ;;
            :)
                echo "Option -$OPTARG requires an argument." >&2
                return 1
                ;;
        esac
    done

    # Check required arguments
    if [[ -z "$model2run" || -z "$customer" || -z "$product" || -z "$norm_version" ]]; then
        echo "Error: Model name, customer, product, and version are required."
        return 1
    fi

    # Prepare vars
    vars="{\"CUSTOMER_DWH\":\"CUSTOMER_PROD_$customer_$product\", \"CUSTOMER_DL\":\"CUSTOMER_PROD_$customer_$product\", \"CUSTOMER\": \"$customer\", \"PRODUCT\": \"$product\", \"VERSION\": \"$norm_version\"}"

    # Add landing_start_date if provided
    if [ -n "$landing_start_date" ]; then
        vars=$(echo $vars | sed 's/}$/,"MIN_LANDING_START_DATE":"'$landing_start_date'"}/')
    fi

    # Add landing_end_date if provided
    if [ -n "$landing_end_date" ]; then
        vars=$(echo $vars | sed 's/}$/,"LANDING_END_DATE":"'$landing_end_date'"}/')
    fi

    export HTTPS_PROXY="http://snowflake-proxy.internal.voyantis.io:8448"

    if [ -n "$extra_args" ]; then
       dbt run -s $model2run $extra_args --vars "$vars" 
    else
       dbt run -s $model2run --vars "$vars" 
    fi
    unset HTTPS_PROXY
}

nohup_run() {
    if [ $# -eq 0 ]; then
        echo "Usage: nohup_run <command>"
        return 1
    fi

    # Remove existing nohup.out if it exists
    [ -f nohup.out ] && rm nohup.out

    # Run the command with nohup and &
    nohup "$@" &

    echo "Command started in background: $@"
}


dotfiles_status() {
  local dotfiles_dir="$HOME/dotfiles"  # Change this to your actual dotfiles directory
  
  # Check if directory exists
  if [[ ! -d "$dotfiles_dir" ]]; then
    echo "Dotfiles directory not found at $dotfiles_dir"
    return 1
  fi
  
  # Change to the dotfiles directory and save the current directory
  local current_dir=$(pwd)
  cd "$dotfiles_dir" || return 1
  
  # Make sure we're in a git repository
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "Not a git repository: $dotfiles_dir"
    cd "$current_dir"
    return 1
  fi
  
  # Fetch the latest changes without merging them
  git fetch origin &>/dev/null
  
  # Get current branch
  local current_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [[ -z "$current_branch" ]]; then
    current_branch="detached HEAD"
  fi
  
  # Get ahead/behind counts for the current branch
  local ahead_behind=$(git rev-list --left-right --count "origin/master...$current_branch")
  local behind=$(echo "$ahead_behind" | awk '{print $1}')
  local ahead=$(echo "$ahead_behind" | awk '{print $2}')
  
  echo "dotfiles (master): $ahead ahead, $behind behind"
  
  # Check for uncommitted changes
  if ! git diff --quiet || ! git diff --staged --quiet; then
    echo "You have uncommitted changes"
  fi
  
  # Return to the original directory
  cd "$current_dir"
}


######################
## AWS EC2 commands ##
######################

export ami1="i-013cae967732eb308"
export datauploader="i-00afe9ad9d378444d"

source $HOME/change_ec2_instance_type.sh
ami_change() {
   change_ec2_instance_type -r -i $ami1 -t $1
}

ami_start() {
    aws ec2 start-instances --instance-ids $ami1
}

ami_stop() {
    aws ec2 stop-instances --instance-ids $ami1
}

ami_status(){
    aws ec2 describe-instance-status --instance-id $ami1
}

scp_to_ami() {
    scp -i ~/.ssh/NotebookServer.pem $1 ubuntu@amihai-ds-notebook.voyantis.co:$2
}

scp_from_ami() {
    scp -i ~/.ssh/NotebookServer.pem ubuntu@amihai-ds-notebook.voyantis.co:$1 $2
}

scp_folder_from_ami() {
    scp -r -i ~/.ssh/NotebookServer.pem ubuntu@amihai-ds-notebook.voyantis.co:$1 $2
}

scp_folder_to_ami() {
    scp -r -i ~/.ssh/NotebookServer.pem $1 ubuntu@amihai-ds-notebook.voyantis.co:$2
}

