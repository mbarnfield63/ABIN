#include <cstdlib>
#include <cstring>
#include <stdio.h>

#include "../tc_mpi_api.h"

//Testing LZ-TeraChem interface
//energies and forces are being read from file
//LZ heavily relies on SH routines for TERAMPI
//this test should indicate if SH changes will break LZ 

using namespace std;

int main(int argc, char* argv[])
{
  char *serverName = NULL;

  // Due to a bug in hydra_nameserver, it crashes
  // when multiple TC servers call `MPI_Unpublish_name()`
  // Hence, we want to allow invoking without this parameter,
  // in which case TC server will just print the port to stdin,
  // where it could be grepped and passed via file to ABIN,
  // and it will never call MPI_Publish_name/MPI_Unpublish_name
  // NOTE: This behaviour is different from real TC,
  // which has default serverName and will always try to publish it.
  if (argc > 2) {
    printf("Only one cmdline argument supported, <serverName>, but you provided more!");
    throw std::runtime_error("Incorrect invocation");
  }

  if (argc == 2) {
    serverName = new char[1024];
    strcpy(serverName, argv[1]);
  }

  TCServerMock tc = TCServerMock(serverName);

  if (serverName) {
    delete[] serverName;
  }

  tc.initializeCommunication();

  tc.receiveNumAtoms();
  tc.receiveAtomTypes();

  tc.FMSNumStates = 3;

  int status = tc.fmsinit_receive();
  if (status == MPI_TAG_EXIT) {
    printf("Got Exit tag before main loop!\n");
    return(1);
  }
  tc.fmsinit_send();

  int loop_counter = 0;
  int MAX_LOOP_COUNT = 100;
  // Will go through this loop until MPI client gives an exit signal.
  while (true) {

    int status = tc.fms_receive();
    if (status == MPI_TAG_EXIT) {
      break;
    }

    //Populate fms_data
    tc.populate_fms_data_from_file(loop_counter);

    //Send them
    tc.fms_send();
      
    // This is just a precaution, we don't want endless loop!
    loop_counter++;
    if (loop_counter > MAX_LOOP_COUNT) {
      printf("Maximum number of steps exceeded!\n");
      return(1);
    }
  }
  
  return(0);
}
