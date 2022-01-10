# 5. Data Encryption

Date: 2022-01-06

## Status

Accepted

## Context

The test-at-home application will be responsible for storing PII for short periods of time. This data
must be protected with the utmost care to prevent unauthorized disclosure.

## Decision

All data will be encrypted in at least two ways.

1) All data in transit will be encrypted using TLS 1.2+
2) All data stored in the database will be subject to full-disk encryption at rest

Additionally, collected PII will be encrypted using "at work" encryption built into ActiveRecord.

More information can be found https://guides.rubyonrails.org/active_record_encryption.html

Non-deterministic encryption should be used for all PII. A new ADR and rationale will need
to be written if it is decided that a piece of PII needs to be queried by, which would make 
deterministic encryption necessary.

## Consequences

These three encryption strategies work hand-in-hand to provide data protection to all data
the test-at-home app will be collecting.


