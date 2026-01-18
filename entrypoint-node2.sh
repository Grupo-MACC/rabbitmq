#!/bin/bash
set -e

rabbitmq-server -detached

# Esperar a que RabbitMQ esté listo
rabbitmqctl await_startup

# Comprobar si ya pertenece a un cluster
if ! rabbitmqctl cluster_status | grep -q "rabbit@rabbitmq-1"; then
  echo "Joining cluster..."
  rabbitmqctl stop_app
  rabbitmqctl join_cluster rabbit@rabbitmq-1
  rabbitmqctl start_app
else
  echo "Already part of the cluster"
fi

# Mantener el contenedor vivo
tail -f /var/log/rabbitmq/*.log
