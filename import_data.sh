
# Create collections
arangoimport \
    --server.endpoint "${ARANGO_ENDPOINT}" \
    --server.username "${ARANGO_USERNAME}" \
    --server.password "${ARANGO_PASSWORD}" \
    --server.database "${ARANGO_DATABASE}" \
    --file "data/kanji.jsonl" \
    --type json \
    --collection "kanji" \
    --create-collection true


arangoimport \
    --server.endpoint "${ARANGO_ENDPOINT}" \
    --server.username "${ARANGO_USERNAME}" \
    --server.password "${ARANGO_PASSWORD}" \
    --server.database "${ARANGO_DATABASE}" \
    --file "data/words.jsonl" \
    --type json \
    --collection "words" \
    --create-collection true


arangoimport \
    --server.endpoint "${ARANGO_ENDPOINT}" \
    --server.username "${ARANGO_USERNAME}" \
    --server.password "${ARANGO_PASSWORD}" \
    --server.database "${ARANGO_DATABASE}" \
    --file "data/kanji-kanji.jsonl" \
    --type json \
    --collection "kanji-kanji" \
    --from-collection-prefix "kanji" \
    --to-collection-prefix "kanji" \
    --create-collection true\
    --create-collection-type edge

# Create Graph
CREATE_GRAPH_CMD=$(cat <<-END
db._useDatabase("${ARANGO_DATABASE}");
var graph_module =  require("org/arangodb/general-graph");
var edgeDefinitions = [ { collection: "kanji-kanji", "from": [ "kanji" ], "to" : [ "kanji" ] } ];
var graph = graph_module._create("graph-kanji",edgeDefinitions);
END
)
echo "${CREATE_GRAPH_CMD}" > tmp.js
arangosh \
  --javascript.execute tmp.js \
  --server.endpoint "${ARANGO_ENDPOINT}" \
  --server.username "${ARANGO_USERNAME}" \
  --server.password "${ARANGO_PASSWORD}" \
  --server.database "${ARANGO_DATABASE}"

 rm tmp.js

