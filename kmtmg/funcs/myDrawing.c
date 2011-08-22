//
//  myDrawing.c
//  kmtmg
//
//  Created by 武村 健二 on 11/08/01.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#include "myDrawing.h"
#include "math.h"
#include "../views/MyViewDataDefines.h"

#define MY_CMP( A, B ) ( !strncmp( A, B, strlen(B)) ? 1 : 0 )
#define MY_COLOR( A, B ) ( ( A == B ) ? 1 : 0 )

// For best performance make bytesPerRow a multiple of 16 bytes.
#define BEST_BYTE_ALIGNMENT 16
#define COMPUTE_BEST_BYTES_PER_ROW(bpr)		( ( (bpr) + (BEST_BYTE_ALIGNMENT-1) ) & ~(BEST_BYTE_ALIGNMENT-1) )

typedef struct {
    long x, y;
} MYPOINT;

static MYPOINT *poolPoint = NULL;
static long poolSize = 0;
static long poolIndex = 0;
static int stopFunc = 0;

void myDraw_allocError()
{
    fprintf(stderr, "Alloc Error!!");
    stopFunc = 1;
}


void myDraw_init()
{
    if( poolPoint != NULL )
        free(poolPoint);
    
    poolPoint = NULL;
    poolSize = 0;
}

int myDraw_poolPoint_init( int size )
{    
    if( poolPoint != NULL && size <= poolSize )
        goto POOLPOINT_INIT;
    
    myDraw_init();
    
    poolPoint = malloc(size * sizeof(MYPOINT));
    if( poolPoint == NULL ) 
    {
        myDraw_allocError();
        return 1;
    }
    poolSize = size;
    
POOLPOINT_INIT:
    poolIndex = 0;
    
    return 0;
}

void myDraw_addPoolPoint( long x, long y )
{
    poolIndex++;
    if( poolSize <= poolIndex )
    {
        poolSize *= 2;
        poolPoint = realloc(poolPoint, sizeof(MYPOINT) * poolSize);
        if( poolPoint == NULL )
        {
            myDraw_allocError();
            myDraw_init();
        }
    }
    poolPoint[poolIndex].x = x;
    poolPoint[poolIndex].y = y;
}

unsigned char *myDraw_getLine( MYID *mi, long y )
{
    if( y < 0 || mi->h <= y ) return NULL;
    
    return mi->d + mi->w * y;
}

int myDraw_get( MYID *mi, long x, long y )
{
    int n = -1;
    
    if( x < 0 || mi->w <= x ) goto END_GET;
    if( y < 0 || mi->h <= y ) goto END_GET;
    
    n = *(mi->d + (long)(mi->w * y + x));
    
END_GET:
    return n;
}

int myDraw_checkEffectIgnore( int d, MYID *mi )
{
    int ret = 0;
    
    if( mi->effectIgnoreType == 0 ) return ret;
    
    if( mi->effectIgnoreType & MVD_IGNORE_MASK )
        d += 256;
    
    if( mi->allow[d] <= 0 ) ret = 1;
    
    return ret;
}

void myDraw_paint( MYID *mi, unsigned int pen )
{
    unsigned char *h_line, *m_line, *l_line;
    long i, x, y, sx, ex, preY = -10;
    int target = -1;
    
    if( myDraw_poolPoint_init(1000) ) return;
    
    stopFunc = 0;
    h_line = m_line = l_line = NULL;

    poolPoint[0].x = mi->sx;
    poolPoint[0].y = mi->sy;
    
    target = myDraw_get(mi, mi->sx, mi->sy);
    
    for ( ; 0 <= poolIndex ; ) 
    {
        x = poolPoint[poolIndex].x;
        y = poolPoint[poolIndex].y;
        poolIndex--;
        
        if( myDraw_get(mi, x, y) == pen ) continue;
        
        sx = x;
        ex = x +1;
        if( (y -1) == preY )
        {
            l_line = m_line;
            m_line = h_line;
            h_line = myDraw_getLine(mi, (y +1));
        }
        else if( (y +1) == preY )
        {
            h_line = m_line;
            m_line = l_line;
            l_line = myDraw_getLine(mi, (y -1));
        }
        else if( y != preY )
        {
            h_line = myDraw_getLine(mi, (y +1));
            m_line = myDraw_getLine(mi, y);
            l_line = myDraw_getLine(mi, (y -1));
        }
        preY = y;
        
        /* 0 < X */
        for( i = sx; 0 <= i; i-- )
        {
            if( m_line == NULL ) break;
            if( MY_COLOR( target, m_line[i] ) )
            {
                if (l_line != NULL && MY_COLOR( target, l_line[i] ) )
                {
                    myDraw_addPoolPoint( i, y-1 );
                }
                if (h_line != NULL && MY_COLOR( target, h_line[i] ) )
                {
                    myDraw_addPoolPoint( i, y+1 );
                }
                
                if( myDraw_checkEffectIgnore(m_line[i], mi) )
                    continue;
                                
                m_line[i] = pen;
                sx = i;
            }
            else break;
            
            if( stopFunc ) break;
        }
        if( stopFunc ) break;
        
        /* X < W */
        for( i = ex; i < mi->w; i++ )
        {
            if( m_line == NULL ) break;
            if( MY_COLOR( target, m_line[i] ) )
            {
                if (l_line != NULL && MY_COLOR( target, l_line[i] ) )
                {
                    myDraw_addPoolPoint( i, y-1 );
                }
                if (h_line != NULL && MY_COLOR( target, h_line[i] ) )
                {
                    myDraw_addPoolPoint( i, y+1 );
                }
                
                if( myDraw_checkEffectIgnore(m_line[i], mi) )
                    continue;
                
                m_line[i] = pen;
                ex = i;
            }
            else break;
            
            if( stopFunc ) break;
        }
        if( stopFunc ) break;
    }
}

void myDraw_dispatch( MYDRAW *md )
{
    if ( MY_CMP(md->cmd, "D_Paint" ) )
    {
        myDraw_paint( &md->dst, md->pen );
    }
}