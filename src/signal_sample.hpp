/*
 * Copyright 2016 Analog Devices, Inc.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with GNU Radio; see the file LICENSE.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street,
 * Boston, MA 02110-1301, USA.
 */

#ifndef SIGNAL_SAMPLE_HPP
#define SIGNAL_SAMPLE_HPP

#include <vector>

#include <QObject>

#include <gnuradio/sync_block.h>

Q_DECLARE_METATYPE(std::vector<float>);

namespace adiscope {
	class signal_sample : public QObject, public gr::sync_block
	{
		Q_OBJECT

	public:
		explicit signal_sample();
		~signal_sample();

		int work(int noutput_items,
				gr_vector_const_void_star &input_items,
				gr_vector_void_star &output_items);

	Q_SIGNALS:
		void triggered(const std::vector<float> &values);
	};
}

#endif
