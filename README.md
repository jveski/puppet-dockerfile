# dockerfile

Build Dockerfiles with Puppet.


## Design
Dockerfile syntax is implementation specific, and a prime candidate to be abstracted by Puppet's DSL.
This module provides a Puppet function which takes a lambda containing Puppet resource declarations, and returns the compiled Dockerfile's contents as a string.
By following this design, anyone who understands the Puppet language can build Docker images without an understanding of Dockerfile syntax.


## Providers
Each resource type declared within the Dockerfile must have a Docker-specific resource provider appropriate for the parent image's distribution.
The `parent_image` resource type is provided to set the parent image's name, and its osfamily for this purpose.

The provider name is prefixed with `docker_`, and suffixed with the value of `parent_image`'s osfamily attribute, i.e. `docker_el`.

Each provider should respond to the `build_script` method, which will be invoked by the dockerfile function during resource evaluation, and provided with a visitor context object.
It is expected that each provider's `build_script` method will return a string to be included in a Dockerfile `CMD` directive.
The command doesn't need to be idempotent since it will only ever be invoked during the container build process.


## Examples
TODO


## Contributing
* Find a TODO or bug
* Fork/branch/commit/PR
* Integration test coverage is important for the function itself (since it's coupled to the Puppet parser)
* Unit tests are fine for types/providers
