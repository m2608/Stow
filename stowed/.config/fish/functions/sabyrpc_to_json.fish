function sabyrpc_to_json -d "Converts sabyrpc object to json"
    jq '
        def record_to_json:     [.d, .s]                  | transpose | map({(.[1].n): .[0]}) | add;

        def recordset_to_json: [[.d, [.s]] | combinations | transpose | map({(.[1].n): .[0]}) | add];

        def object_to_json:
            if type == "object" and ._type != null and .d != null and .s != null then
                if   ._type == "record"    then record_to_json
                elif ._type == "recordset" then recordset_to_json
                else .
                end
            else .
            end
        ;

        walk(object_to_json)
    '
end
