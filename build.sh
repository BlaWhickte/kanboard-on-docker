#! /bin/bash
getLatestKanboard() {
    TEMP_FILE=$(mktemp)
    FINALLY_FOLDER="kanboard/"
    curl --silent -o $TEMP_FILE https://api.github.com/repos/kanboard/kanboard/releases/latest
    LATEST_VERSION=$(sed 'y/,/\n/' "$TEMP_FILE" | grep 'tag_name' | awk -F '"' '{print $4}')
    SAVENAME=$LATEST_VERSION.zip
    URL=https://github.com/kanboard/kanboard/archive/$SAVENAME
    wget --no-verbose $URL
    TEMP_FILE=$(mktemp)
    unzip $SAVENAME >>$TEMP_FILE
    EXTRACT_FOLDER=$(cat $TEMP_FILE | grep -i "creating" | head -n 1 | awk '{print $2}')
    mv $EXTRACT_FOLDER $FINALLY_FOLDER
    rm -r ./$SAVENAME

    cp $FINALLY_FOLDER/config.default.php $FINALLY_FOLDER/config.php
    URL_REWRITE_LINE=$(awk '/ENABLE_URL_REWRITE/{print NR}' $FINALLY_FOLDER/config.php)
    sed -i "$URL_REWRITE_LINE d" $FINALLY_FOLDER/config.php
    sed -i "N;222adefine('ENABLE_URL_REWRITE',true);" $FINALLY_FOLDER/config.php
}

build_image() {
    docker build -t local/kanboard:latest .
}

run_container() {
    docker run -i -t -d --name=kanboard_local -v $PWD/kanboard:/var/www/app -p 9982:80  local/kanboard:latest
}

main(){
    getLatestKanboard
    build_image
    run_container
}

main
