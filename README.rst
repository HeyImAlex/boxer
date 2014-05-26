boxer
-----

Little shell utility that helps you package Vagrant boxes. Just ``cd``
to a directory where you have a Vagrantfile and associated provisioning
scripts and call ``boxer box NAME``. The script will provision the box
according to the Vagrantfile, repackage it as ``NAME``, and then clean
up after itself.

::

    boxer <COMMAND>

    Used to build, package, and add vagrant boxes.

    commands:
        box <NAME> : builds the box, packages it, adds it, and cleans up
        provision : provisions the box (basically just vagrant up)
        package <NAME> : packages and adds the currently running box
        clean : destroys the currently running box and deletes .vagrant

If the build fails, you can fix your provisioning scripts and try again,
or, if the install needs to be restarted completely, run ``boxer clean``
first. The script is just a thin wrapper around a few Vagrant commands,
so intervening manually (say, to only run certain provisioners) can be
done by just calling Vagrant directly.

Used to manage my base development boxes. Something like packer_ seemed
too heavy-weight and added a lot of complexity compared to just doing it
inside of Vagrant.

.. _packer: http://www.packer.io/