define ubi-add-vol
	echo "[$2]\n"\
		"\tmode=ubi\n"\
		"\tvol_id=$1\n"\
		"\tvol_name=$2\n"\
		"\tvol_size=$3\n"\
		"\tvol_type=$4\n"\
		"\timage=$5\n"\
		"\tvol_alignment=1\n"\
		>> ubinize.cfg.tmp
endef
