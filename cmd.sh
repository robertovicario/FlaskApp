#!/bin/bash

start() {
    if [ $2 == "-d" ]; then
        printer "🚀 Starting the app"
        docker-compose up -d
        handler
    else
        printer "🚀 Starting the app"
        docker-compose up
        handler
    fi
}

stop() {
    printer "🛑 Stopping the app"
    docker-compose down
    handler
}

build() {
    if [ $2 == "-d" ]; then
        printer "🔨 Setting up the app"
        docker-compose up --build -d
        handler
    else
        printer "🔨 Setting up the app"
        docker-compose up --build
        handler
    fi
}

clear() {
    printer "🧹 Clearing all"
    docker-compose down --volumes --rmi all
    handler
}

deploy() {
    printer "🚀 Deploying the app"
    cd app
    python app.py build
    cd ..
    git add .
    git commit -m "Deployed the app"
    git push
    handler
}

printer() {
    echo ""
    echo $1
    echo ""
}

handler() {
    if [ $? -eq 0 ]; then
        printer "✅ Process completed successfully"
    else
        printer "❌ An error occurred during the process"
        exit 1
    fi
}

case $1 in
    start)
        start $@
        ;;
    stop)
        stop
        ;;
    build)
        build $@
        ;;
    clear)
        clear
        ;;
    deploy)
        deploy
        ;;
    *)
        echo "Usage: $0 {start|stop|build|clear|deploy}"
        ;;
esac
