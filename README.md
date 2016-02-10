# dockerfile

Build Dockerfiles with Puppet.


## Design
Dockerfile syntax is implementation specific, and a prime candidate to be abstracted by Puppet's DSL.
This module provides a Puppet function which takes a lambda containing Puppet resource declarations, and returns the compiled Dockerfile's contents as a string.
By following this design, anyone who understands the Puppet language can build Docker images without an understanding of Dockerfile syntax.


## Providers
Each resource type declared within the Dockerfile must have a Docker-specific resource provider.
The `parent_image` resource type is provided to set the parent image's name, and its osfamily for this purpose.

A resource's Dockerfile provider can be platform specific or generic.
Generic providers are simply named `docker` and should theoretically support any container distribution.
Platform specific providers are named `docker_${osfamily}`, and will take precedence over the generic provider if both are provided.

Any Dockerfile provider should respond to the `dockerfile_line` method, which will be invoked by the dockerfile function during resource evaluation, and provided with a visitor context object.
It is expected that each provider's `dockerfile_line` method will return a string to be included in a Dockerfile.


## Examples
TODO


## Contributing
* Find a TODO or bug
* Fork/branch/commit/PR
* Integration test coverage is important for the function itself (since it's coupled to the Puppet parser)
* Unit tests are fine for types/providers
