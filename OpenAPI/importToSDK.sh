FROM_PREFIX=src/generated/OpenAPIClient/Classes/OpenAPIs/
TO_PREFIX=../Sources/SpiralSDK/Classes/API/

while read file; do
  echo "Copying $file..."
  cp $FROM_PREFIX$file $TO_PREFIX$file
done <filesToImport.txt
