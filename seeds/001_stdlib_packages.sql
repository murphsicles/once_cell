-- Seed: Official Zeta Standard Library packages
-- Run on fresh database to populate baseline packages matching zorbs.io
--
-- Usage: PGPASSWORD=zorbs_dev psql -h localhost -U zorbs -d zorbs -f seeds/001_stdlib_packages.sql

INSERT INTO zorbs (id, name, version, description, license, repository, dependencies, downloads, created_at, updated_at)
VALUES
  (gen_random_uuid(), '@data/serde',     '0.4.0',  'Serialization/Deserialization framework for Zeta',                               'MIT',               'https://github.com/murphsicles/serde',     '{}',                                                        0, '2026-05-07 07:52:14.493674+00', '2026-05-07 07:52:14.493674+00'),
  (gen_random_uuid(), '@async/tokio',    '0.3.10', 'Epoll-based multi-threaded async runtime for Zeta with reactor, waker, timerfd', 'MIT',               'https://github.com/murphsicles/tokio',     '{}',                                                        0, '2026-05-07 07:52:14.506593+00', '2026-05-11 00:22:55.864894+00'),
  (gen_random_uuid(), '@http/axum',      '0.8.1',  'Ergonomic web framework',                                                         'MIT',               'https://github.com/zeta-lang/axum',        '{"@http/hyper": "^1.3", "@async/tokio": "^1.42"}',        0, '2026-05-07 07:52:14.508126+00', '2026-05-07 07:52:14.508126+00'),
  (gen_random_uuid(), '@log/tracing',    '0.2.5',  'Structured, performant logging',                                                 'MIT',               'https://github.com/zeta-lang/tracing',     '{"@core/once_cell": "^1.19"}',                             0, '2026-05-07 07:52:14.510041+00', '2026-05-07 07:52:14.510041+00'),
  (gen_random_uuid(), '@cli/clap',       '4.5.0',  'Command line argument parser',                                                    'MIT OR Apache-2.0', 'https://github.com/zeta-lang/clap',        '{}',                                                        0, '2026-05-07 07:52:14.510962+00', '2026-05-07 07:52:14.510962+00'),
  (gen_random_uuid(), '@core/once_cell', '1.0.0',  'Single assignment cells and lazy values for Zeta.',                               'MIT', 'https://github.com/murphsicles/once_cell', '{}',                                                        0, '2026-05-14 23:55:41.616911+00', '2026-05-15 00:14:22.112998+00')
ON CONFLICT (name, version) DO NOTHING;
