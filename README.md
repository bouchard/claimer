# Claimer

Claimer is a Ruby library for preparing, formatting and submitting claim submissions for Medicare services provided by physicians in Canada. Each province uses a different process for submissions - this library aims to abstract away these differences.

## Working:

* **Saskatchewan** (hospital and out-of-hospital billing).

## TODO

* Every other province.
* Support for out-of-province billing.
* Support for return record / paylist parsing into an intelligible format.

## HOWTO

Initialize a provincial gateway, add records, and then call ```finalize!``` to generate the correct file for submission.

```
@gateway = Claimer::SKGateway.new
@gateway.add_record(:hsn => @patient.hsn, ...)
@gateway.finalize!
```
