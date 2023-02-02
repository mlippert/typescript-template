/* ******************************************************************************
 * index.ts                                                                     *
 * *************************************************************************/ /**
 *
 * @fileoverview Application Entry Point
 *
 * Created on       February 2, 2023
 * @author          Michael Jay Lippert
 *
 * @copyright (c) 2023 Michael Jay Lippert,
 *            MIT License (see https://opensource.org/licenses/MIT)
 *
 * ******************************************************************************/

import bunyan from 'bunyan';
import config from 'config';

const log = bunyan.createLogger({ name: 'myapp' });
log.info(config.get('hello'));
