function sabyrpc -d "Converts sabyrpc object to json"
    jq '
        def value_of_type($d; $s):
            if $s.t | type == "object" then
                if $s.t.n == "Флаги" then
                    {($s.n): ([$d, $s.t.s | to_entries | map(.value)] | transpose | map({(.[1]): .[0]}) | add)}
                else {($s.n): $d}
                end
            else {($s.n): $d}
            end
        ;

        def record_to_json:     [.d, .s]                  | transpose | map(value_of_type(.[0]; .[1])) | add;

        def recordset_to_json: [[.d, [.s]] | combinations | transpose | map(value_of_type(.[0]; .[1])) | add];

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
