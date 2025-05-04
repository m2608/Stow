function scl-enable
    set vars (mktemp -t scl-vars.XXXXXXXX)

	# Get only new variables.
	comm -13 (bash -c "export -p" | sort | psub) (bash -c "source /opt/rh/$argv[1]/enable && export -p" | sort | psub) \
    	| sed -n '/^declare -x /p' \
    	| sed 's/^declare -x //' \
    	> "$vars"

	# Set those vars in fish session.
    for line in (cat "$vars")
        set name (echo $line | cut -d '=' -f 1)
        set value (echo $line | cut -d '=' -f 2 | sed -r 's/^"(.*)"$/\1/')
        set -x $name $value
    end

    rm "$vars"
end
