#!/bin/sh

config_path="${PWD}/.alexandria/alexandria-config.json"

if [ ! -f "$config_path" ]; then
	exit 0
fi

if ! command -v ax >/dev/null 2>&1; then
	exit 0
fi

has_connection_args=false
connection_id="${ALEXANDRIA_CLAUDE_CONNECTION_ID:-host:claude-code:default}"
next_is_connection=false
for arg in "$@"; do
	if [ "$next_is_connection" = true ]; then
		connection_id="$arg"
		next_is_connection=false
		continue
	fi

	case "$arg" in
	--connection)
		has_connection_args=true
		next_is_connection=true
		;;
	--connection=*)
		has_connection_args=true
		connection_id="${arg#--connection=}"
		;;
	esac
done

if [ "$has_connection_args" = false ]; then
	set -- --connection "$connection_id" --cursor "$connection_id" "$@"
fi

ax inspect subscriptions register \
	--subscription "${connection_id}:raven-vision" \
	--connection "$connection_id" \
	--type raven.vision.source_attached \
	--type raven.vision.drafting_requested \
	--type raven.vision.slot.approved \
	--type raven.vision.slot.skipped \
	--if-missing \
	--json >/dev/null 2>&1 || true

exec ax internal host claude monitor "$@"
