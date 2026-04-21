#!/usr/bin/env bash

# ==============================
# CONFIG: add your repo paths here
# ==============================
REPOS=(
	"$HOME/.local/share/caelestia/"
	"$HOME/.config/quickshell/overview/"
)

# ==============================
# SCRIPT
# ==============================

for repo in "${REPOS[@]}"; do
	echo "----------------------------------------"
	echo "📁 Processing: $repo"

	if [ ! -d "$repo/.git" ]; then
		echo "❌ Not a git repo, skipping..."
		continue
	fi

	cd "$repo" || continue

	# Check for changes
	if ! git diff --quiet || ! git diff --cached --quiet; then
		echo "⚠️  Changes detected"

		git add -A
		git commit -m "auto-commit before pull ($(date))"

		if [ $? -eq 0 ]; then
			echo "📦 Changes commited"
		else
			echo "❌ Failed to commit, skipping pull"
			continue
		fi
	else
		echo "✅ Clean working tree"
	fi

	# Pull latest changes
	git pull --rebase || {
		echo "Conflict → keeping local changes"
		git rebase --abort 2>/dev/null
		git pull --rebase -X ours
	}

done

echo "----------------------------------------"
echo "🎉 Done!"
