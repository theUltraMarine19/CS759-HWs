#include "optimize.h"

data_t *get_vec_start(vec *v) {
	return v->data;
}

void optimize1(vec *v, data_t *dest) {
	int len = v->len;
	data_t *d = get_vec_start(v);
	data_t temp = IDENT;
	for (int i = 0; i < len; i++) {
		temp = temp OP d[i];
	}
	*dest = temp;
}

void optimize2(vec *v, data_t *dest) {
	int len = v->len;
	int limit = len-1;
	data_t *d = get_vec_start(v);
	data_t temp = IDENT;
	int i;

	for (i = 0; i < limit; i+=2) {
		temp = (temp OP d[i]) OP d[i+1];
	}
	for (; i < len; i++) {
		temp = temp OP d[i];
	}
	*dest = temp;
}

void optimize3(vec *v, data_t *dest) {
	int len = v->len;
	int limit = len-1;
	data_t *d = get_vec_start(v);
	data_t temp = IDENT;
	int i;

	for (i = 0; i < limit; i+=2) {
		temp = temp OP (d[i] OP d[i+1]);
	}
	for (; i < len; i++) {
		temp = temp OP d[i];
	}
	*dest = temp;
}

void optimize4(vec *v, data_t *dest) {
	int len = v->len;
	int limit = len-1;
	data_t *d = get_vec_start(v);
	data_t temp1 = IDENT;
	data_t temp2 = IDENT;
	int i;

	for (i = 0; i < limit; i+=2) {
		temp1 = temp1 OP d[i];
		temp2 = temp2 OP d[i+1];
	}
	for (; i < len; i++) {
		temp1 = temp1 OP d[i];
	}
	*dest = temp1 OP temp2;

}

void optimize5(vec *v, data_t *dest) {
	int len = v->len;
	int limit = len-2;
	data_t *d = get_vec_start(v);
	data_t temp1 = IDENT;
	data_t temp2 = IDENT;
	data_t temp3 = IDENT;
	int i;

	for (i = 0; i < limit; i+=3) {
		temp1 = temp1 OP d[i];
		temp2 = temp2 OP d[i+1];
		temp3 = temp3 OP d[i+2];
	}
	for (; i < len; i++) {
		temp1 = temp1 OP d[i];
	}
	*dest = temp1 OP temp2 OP temp3;
}
