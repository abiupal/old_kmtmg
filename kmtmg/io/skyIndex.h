/*
//  index.h
//
//  SKY .idx ファイル定義
//  
//  Created by 武村　健二 on Fri Nov 29 2002.
//  Copyright (c) 1994-2002 J.T.S.TAKEMURA CO.,LTD. All rights reserved.
//  Copyright (c) 2002-2008 Oriya Inc. All rights reserved.
//
*/
#ifndef _SKYINDEX_H_
#define _SKYINDEX_H_

/* SKY-64 */
typedef struct {
	char f_name[12] ;
	short rorx ;
	short rory ;
	short mode ;
	short curm ;
	short bold ;
	unsigned short bksw ;
	short penc ;
	short bgrc ;
	short zoomx ;
	short zoomy ;
	short dots ;
	short orgx ;
	short orgy ;
	short endx ;
	short endy ;
	short patx12 ;
	short paty12 ;
	
	/*map*/
	short org_x ;
	short org_y ;
	unsigned char stepx[8] ;
	unsigned char stepy[8] ;
	short offox ;
	short offoy ;
	unsigned char mapof ;
	unsigned char mtrx[2] ;
	unsigned char mtry ;
	
	/*etc*/
	short version ;
	short level ;
	short reserve2 ;
	short max_stl ;
	short dammy1 ;
	short cads ;
	unsigned char  patx3;
	unsigned char  paty3;
	int	  patx;
	int	  paty;
}c_index ;

#endif
