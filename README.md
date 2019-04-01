# Container to create PostgreSQL Backups
Minimalisitic container (only 25MB) for backing up Postgres databases.

## Goal

Easily backup your PostgreSQL Database.

Intended to be used with:
1. Kubernetes for creating CronJobs that periodically back up your database.
2. Container Instances (e.g Azure Container Instances, AWS Fargate) that can be scheduled at specified times.
3. Your computer! It's smaller than pgAdmin.

## Running manually on your computer
* Use `PGHOST`, `PGUSER` and `PGDATABASE` environment variables implicitly (see Dockerfile for defaults) for `pg_dump` invocation:

	`docker run -v /host/backup_dir:/pg_backup robotany/postgres-backup`

