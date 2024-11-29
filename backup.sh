#!/bin/bash

source "$(dirname "$0")/config.sh"

if [ ! -d "$BACKUP_DIR" ]; then
  echo "Criando diretório de backup em $BACKUP_DIR..."
  mkdir -p "$BACKUP_DIR"
fi

log_message() {
  local MESSAGE=$1
  echo "$(date +"%Y-%m-%d %H:%M:%S") - $MESSAGE" >> "$LOG_FILE"
}

log_message "Iniciando o backup..."
BACKUP_FILE="$BACKUP_DIR/backup_$(date +"%Y%m%d_%H%M%S").tar.gz"

tar -czf "$BACKUP_FILE" -C "$SOURCE_DIR" .
if [ $? -eq 0 ]; then
  log_message "Backup concluído com sucesso! Arquivo: $BACKUP_FILE"
else
  log_message "Erro durante o processo de backup."
  exit 1
fi

if [ "$ENABLE_RETENTION" = "true" ]; then
  log_message "Verificando retenção de backups antigos..."
  find "$BACKUP_DIR" -type f -name "backup_*.tar.gz" -mtime +"$RETENTION_DAYS" -exec rm {} \;
  log_message "Backups antigos removidos."
fi

log_message "Processo de backup finalizado."
echo "Backup concluído! Verifique o log em $LOG_FILE."
