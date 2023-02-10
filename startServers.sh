echo "Starting server for component1..."
REAL_PATH=`readlink -f ./component1/build/web`
docker run -it --rm -d -p 8080:80 --name "flutter-component-1" -v $REAL_PATH:/usr/share/nginx/html nginx

echo "Starting server for component2..."
REAL_PATH=`readlink -f ./component2/build/web`
docker run -it --rm -d -p 8081:80 --name "flutter-component-2" -v $REAL_PATH:/usr/share/nginx/html nginx