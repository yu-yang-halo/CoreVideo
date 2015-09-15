
#include "FileList.h"
#include <sys/stat.h>
#include <stdlib.h>

CFileList::CFileList(void)
{
    
}

CFileList::~CFileList(void)
{
	m_FileList.clear();
}

void CFileList::InitNode(FileNode_t &node)
{
	node.filepath = "";
	node.filename = "";
	node.assist_filepath = "";
	node.file_dt ="";
	node.duration = 0;
	node.rd_only = 0;
	node.is_sunplus = 0;
	node.is_a7l = 0;
	node.is_novatek = 0;
}

//@20121214
void CFileList::CheckPlatform(FileNode_t &node, string szFilePath)
{
	char sFile[PATH_MAX] = {0};
	char buf[16] = {0};

	sprintf(sFile, "%s", szFilePath.data());

	FILE *fd = NULL;
	fd = fopen(sFile, "rb");
	if(fd == NULL) return;

	{	//Check Sunplus platform 
		fseek(fd, 0, SEEK_END);
		fseek(fd, -8, SEEK_CUR);		
		fread(buf, 1, 8, fd);	
		buf[9] = '\0';

		if(strcmp(buf, "ICAT6330") == 0) {
			node.is_sunplus = 1;
		}
	}

	if(node.is_sunplus == 1) {
		fclose(fd);
		fd = NULL;
		return;
	}	

	{	//Check A7L platform @20130627
#define ENDIAN_CONV(b)	(b[0] << 24 | b[1] << 16 | b[2] << 8 | b[3])
		do{
			char rbuf[64] = {0};
			unsigned char chSize[8] = {0};
			char chFlag[8] = {0};
			unsigned int size = 0;
			unsigned int check_flag = 0, pos = 0;
			unsigned int cnt = 0;

			fseek(fd, 0, SEEK_SET);
			while(!feof(fd)) {
				if(fread(chSize, 1, 4, fd) != 4) break;		//get address
				size = ENDIAN_CONV(chSize);		//convert size			
				if(fread(chFlag, 1, 4, fd) != 4) break;

				pos += size;
				printf(" [0x%08X]%s - Pos:0x%08X\n", *((unsigned int*)chSize), chFlag, pos);

				if(strcmp(chFlag, "moov") == 0) {
					check_flag = 1;
					break;
				}
				fseek(fd, size-8, SEEK_CUR);
				cnt ++;
				if(cnt >= 128) break;
			}
			if(check_flag == 0) break;

			check_flag = 0;
			cnt = 0;
			while(!feof(fd)) {
				if(fread(chSize, 1, 4, fd) != 4) break;		//get address
				size = ENDIAN_CONV(chSize);		//convert size			
				if(fread(chFlag, 1, 4, fd) != 4) break;

				pos += size;
				printf("         [0x%08X]%s - Pos:0x%08X\n", *((unsigned int*)chSize), chFlag, pos);

				if(strcmp(chFlag, "udta") == 0) {
					memset(rbuf, 0, 64);
					if(fread(chSize, 1, 4, fd) != 4) break;		//get address
					size = ENDIAN_CONV(chSize);		//convert size
					if(size > 64) size = 64;
					if(size > 0) {
						if(fread(rbuf, 1, size, fd) != size) break;
						if(strstr(rbuf, "AMBARELLA A7L") != NULL) {
							node.is_a7l = 1;
						} else if(strstr(rbuf, "NT96650A") != NULL) {
							node.is_novatek = 1;
						}
					}
					break;
				}
				fseek(fd, size-8, SEEK_CUR);
				cnt++;
				if(cnt >= 128) break;
			}

		} while(0);			
	}

	fclose(fd);
	fd = NULL;

	return;
}

FileNode_t CFileList::createNodeInfo(string szFilePath)
{
	FileNode_t	node;

	InitNode(node);
    char fpath[1024];
    sprintf(fpath, "%s",szFilePath.data());
    
    node.filepath=fpath;
    
    
     CheckPlatform(node, szFilePath);

	return node;
}
