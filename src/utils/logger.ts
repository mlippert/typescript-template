/* ******************************************************************************
 * logger.ts                                                                    *
 * *************************************************************************/ /**
 *
 * @fileoverview Sets up and exports the Bunyan logger
 *
 * Created on       February 3, 2023
 * @author          Michael Jay Lippert
 *
 * @copyright (c) 2023 Michael Jay Lippert,
 *            MIT License (see https://opensource.org/licenses/MIT)
 *
 * ******************************************************************************/

import bunyan from 'bunyan';
import config from 'config';
import type { LoggerOptions } from 'bunyan';

// Set up the bunyan logger using the options specified in config. Handle special
// streams stdout and stderr in the config.
const logOptions: LoggerOptions = config.util.toObject(config.get('log'));
replaceStdoutStderrStringWithStream(logOptions);
logOptions.streams && logOptions.streams.forEach(s => replaceStdoutStderrStringWithStream(s));

const logger = bunyan.createLogger(logOptions);

/* ******************************************************************************
 * replaceStdoutStderrStringWithStream                                     */ /**
 *
 * Replaces the string 'stdout' or 'stderr' value of the stream property of
 * the given object with the actual stream object from `process`.
 */
function replaceStdoutStderrStringWithStream(o: any): void {
    if (o.stream === 'stdout' || o.stream === 'stderr') {
        o.stream = process[o.stream];
    }
}


/* **************************************************************************** *
 * Module exports                                                               *
 * **************************************************************************** */
export {
    logger,
};
