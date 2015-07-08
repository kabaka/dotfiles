#!/usr/bin/env zsh

MY_PATH="$0:a:h"
DEST_PATH="${HOME}"
BACKUP_PATH="${MY_PATH}/backup"

echo "Installing from ${MY_PATH} to ${DEST_PATH}..."

for DOTFILE in "${MY_PATH}"/.*; do
  DOTFILE_BASENAME="$(basename "${DOTFILE}")"

  DEST_FILENAME="${DEST_PATH}/${DOTFILE_BASENAME}"
  BACKUP_FILENAME="${BACKUP_PATH_PATH}/${DOTFILE_BASENAME}"

  if [[ $DOTFILE_BASENAME =~ ^\.\.?$ || ( $DOTFILE_BASENAME =~ "^.git.*$" && $DOTFILE_BASENAME != ".gitconfig" ) ]];
  then continue
  fi

  echo -n "  ${DOTFILE}..."

  if [ -L "${DEST_FILENAME}" ]; then
    rm "${DEST_FILENAME}"

    echo -n " cleaned..."

  elif [ -f "${DEST_FILENAME}" ]; then
    cp -rav "${DEST_FILENAME}" "${BACKUP_FILENAME}"

    echo -n " backed up..."

  fi

  ln -s "${DOTFILE}" "${DEST_FILENAME}"

  echo " installed"
done
