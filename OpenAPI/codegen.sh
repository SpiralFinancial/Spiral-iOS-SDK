#
# Export the current .env file for use in this script
#
set -o allexport; source .env; set +o allexport
#
# We need the SWAGGER env key to securely request from Nexus storage.
#
if [ -n "$SWAGGER_API_KEY" ]; then
  #
  # Request the zip folder
  #
  curl -u spiral_ro:${SWAGGER_API_KEY} -v -L --output ./open-api.zip -X GET "http://spiral-nexus-external.spiral.us:8081/service/rest/v1/search/assets/download?group=%22us.spiral%22&name=%22open-api%22&sort=version&direction=desc";
  #
  # Unzip it in a temporary directory
  #
  unzip -d ./tmp/ open-api.zip;
  #
  # Remove the initial zip
  #
  rm -rf open-api.zip; 
  #
  # Remove the existing generated files
  #
  rm -rf src/generated; 
  #
  # Run codegen and output in the generated folder
  #
#  openapi-generator generate -i ./tmp/openapi-v1.yaml -g swift5 -o src/generated;
  openapi-generator generate -i ./openapi-ios-v1.yaml -g swift5 -o src/generated;
  #
  # Move the open api .yaml file to the generated folder
  #
  # mv -i ./tmp/openapi-v1.yaml ./src/generated;
  cp ./openapi-ios-v1.yaml ./src/generated;
  #
  # Delete the temporary folder
  #
  rm -rf tmp;
  #
  # Format with prettier for consistency
  #
  yarn format;
  #
  # Import specific generated files into the SDK
  #

#  ./importToSDK.sh
  
  echo #########################
  echo #########################
  echo 🤖 Codegen complete - Nice work!; 
  echo #########################
  echo Find the latest generated schema here:;
  echo 🔵 src/generated;
  echo #########################
  echo #########################
else
  echo #########################
  echo #########################
  echo "🔴 SWAGGER_API_KEY is required to perform this action."
  echo "🔴 Add SWAGGER_API_KEY to your .env"
  echo #########################
  echo #########################
fi
