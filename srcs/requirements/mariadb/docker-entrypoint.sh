#!/bin/bash
set -e

# Start mysqld in background
/usr/sbin/mysqld &
MYSQLD_PID=$!

# Wait for mysqld socket to be available (more reliable than ping)
echo "Waiting for mysqld to be ready..."
for i in {60..0}; do
  if [ -S /run/mysqld/mysqld.sock ] && mysqladmin -u root ping --socket=/run/mysqld/mysqld.sock &>/dev/null; then
    echo "mysqld is ready"
    break
  fi
  if [ $i -eq 0 ]; then
    echo "mysqld failed to start"
    kill $MYSQLD_PID 2>/dev/null || true
    exit 1
  fi
  sleep 1
done

# Run initialization scripts (shell and SQL) if present
if [ -d "/docker-entrypoint-initdb.d" ]; then
  for f in /docker-entrypoint-initdb.d/*; do
    case "$f" in
      *.sh)
        echo "Running $f"
        # Source the script directly
        if bash "$f"; then
          echo "Init script $f completed successfully"
        else
          echo "Init script $f failed with exit code $?"
          kill $MYSQLD_PID 2>/dev/null || true
          exit 1
        fi
        ;;
      *.sql)
        echo "Applying $f"
        mysql -u root --socket=/run/mysqld/mysqld.sock < "$f" || {
          echo "SQL script $f failed"
          kill $MYSQLD_PID 2>/dev/null || true
          exit 1
        }
        ;;
      *)
        echo "Ignoring $f"
        ;;
    esac
  done
fi

# Wait for mysqld process to complete
wait $MYSQLD_PID
